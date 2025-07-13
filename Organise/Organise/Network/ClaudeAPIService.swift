//
//  ClaudeAPIService.swift
//  Organise
//
//  Created by David Fitzgerald on 11/06/2025.
//

import Foundation

enum ClaudeAPIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case networkError(Error)
    case rateLimitExceeded
    case serverError(String)
    case invalidEmojiResponse
    case invalidEmojiUnicode
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key not configured. Please check your configuration."
        case .invalidResponse:
            return "Invalid response from Claude API."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .serverError(let message):
            return "Server error: \(message)"
        case .invalidEmojiResponse:
            return "Failed to generate emoji. Using default emoji instead."
        case .invalidEmojiUnicode:
            return "Invalid emoji received from API. Using default emoji instead."
        }
    }
}

struct ClaudeAPIService {
    static let claudeAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let key = config["ClaudeAPIKey"] else {
            return ""
        }
        return key as! String
    }()

    static let baseURL = URL(string: "https://api.anthropic.com/v1")!
    static let messagesEndpoint = baseURL.appendingPathComponent("messages")
    
    static func validateEmoji(_ character: Character) -> Character {
        guard !character.isWhitespace else { return "❓" }
        
        // If it's a valid emoji, return it
        if character.isEmoji {
            return character
        }
        
        // If not valid, return a fallback emoji
        return "❓"
    }

    static func createRequest() throws -> URLRequest {
        // Validate API key
        guard !claudeAPIKey.isEmpty else {
            throw ClaudeAPIError.missingAPIKey
        }
        
        var request = URLRequest(url: messagesEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue(claudeAPIKey, forHTTPHeaderField: "x-api-key")
        return request
    }
    
    static func prompt(
        content: String,
        maxTokens: Int = 10,
        model: String = "claude-sonnet-4-20250514",
    ) async throws -> (Data, URLResponse) {
        /**
         * Send a prompt to Claude and return a response.
         */
        var request = try createRequest()
    
        let body: [String: Any] = [
            "model": model,
            "max_tokens": maxTokens,
            "messages": [
                [
                    "role": "user",
                    "content": content,
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        print("Making request to: \(messagesEndpoint.absoluteString)")
        
        return try await URLSession.shared.data(for: request)
    }

    static func suggestEmoji(for name: String) async throws -> Character {
        do {
            let (data, response) = try await prompt(content:
                "Suggest the best emoji for depicting \(name). Favour emojis that appear happier, more positive, cleaner, more fun, productive, exciting, etc. Reply with only the single emoji character.", maxTokens: 1
            )

            // Check HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success
                case 429:
                    throw ClaudeAPIError.rateLimitExceeded
                case 500...599:
                    throw ClaudeAPIError.serverError("HTTP \(httpResponse.statusCode)")
                default:
                    throw ClaudeAPIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let decodedData = try JSONSerialization.jsonObject(with: data) as! [String : Any]
            
            print("Got \(decodedData) back from Claude.")
            
            // Extract the emoji from the response
            if let content = decodedData["content"] as? [[String: Any]],
               let firstContent = content.first,
               let text = firstContent["text"] as? String,
               !text.isEmpty {
                let character = text.first!
                
                print("Character received: \(character)")
                
                // Validate the emoji
                let emoji = validateEmoji(character)

                
                print("Validated emoji: \(emoji)")
                return emoji
            } else {
                print("Failed to parse emoji from response")
                throw ClaudeAPIError.invalidEmojiResponse
            }
            
        } catch let error as ClaudeAPIError {
            // Re-throw our custom errors
            throw error
        } catch {
            // Wrap other errors
            throw ClaudeAPIError.networkError(error)
        }
    }
    
    static func suggestEmojiWithRetry(for name: String, maxRetries: Int = 2) async throws -> Character {
        var lastError: Error?
        
        for attempt in 1...maxRetries {
            do {
                return try await suggestEmoji(for: name)
            } catch {
                lastError = error
                
                // Don't retry on certain errors
                if let claudeError = error as? ClaudeAPIError {
                    switch claudeError {
                    case .missingAPIKey, .invalidResponse, .invalidEmojiResponse, .invalidEmojiUnicode:
                        throw claudeError // Don't retry these
                    default:
                        break // Retry other errors
                    }
                }
                
                // Wait before retry (exponential backoff)
                if attempt < maxRetries {
                    let delay = Double(attempt) * 1.0 // 1s, 2s delays
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        // If we get here, all retries failed
        throw lastError ?? ClaudeAPIError.networkError(NSError(domain: "Unknown", code: -1))
    }
}
