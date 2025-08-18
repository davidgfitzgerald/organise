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
    case invalidIconResponse
    case invalidIcon
    
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
        case .invalidIconResponse:
            return "Failed to generate icon. Using default icon instead."
        case .invalidIcon:
            return "Invalid icon received from API. Using default icon instead."
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
    
    static func validateIcon(_ string: String) -> String {
        guard !string.isEmpty else { return "questionmark.app.fill" }
        
        // If it's a valid icon, return it
        if string.isValidSFSymbol {
            return string
        }
        
        // If not valid, return a fallback icon
        return "questionmark.app.fill"
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
        maxTokens: Int = 50,
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
        
        AppLogger.info("Making request to: \(messagesEndpoint.absoluteString)")
        
        return try await URLSession.shared.data(for: request)
    }

    static func suggestIcon(for name: String) async throws -> String {
        do {
            let (data, response) = try await prompt(content:
                "Suggest the best SF Symbol string for depicting \(name). Favour SF Symbols that appear happier, more positive, cleaner, more fun, productive, exciting, etc. Reply with ONLY the single SF Symbol string for use in an API call (e.g. 'drop.fill').",
//                                                    maxTokens: 50
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
            
            AppLogger.info("Got \(decodedData) back from Claude.")
            
            // Extract the icon from the response
            if let content = decodedData["content"] as? [[String: Any]],
               let firstContent = content.first,
               let text = firstContent["text"] as? String,
               !text.isEmpty {                
                AppLogger.info("Response received: \(text)")
                
                // Validate the icon
                let text = validateIcon(text)

                AppLogger.info("Validated icon: \(text)")
                return text
            } else {
                AppLogger.error("Failed to parse icon from response")
                throw ClaudeAPIError.invalidIconResponse
            }
            
        } catch let error as ClaudeAPIError {
            // Re-throw our custom errors
            throw error
        } catch {
            // Wrap other errors
            throw ClaudeAPIError.networkError(error)
        }
    }
    
    static func suggestIconWithRetry(for name: String, maxRetries: Int = 2) async throws -> String {
        var lastError: Error?
        
        for attempt in 1...maxRetries {
            do {
                return try await suggestIcon(for: name)
            } catch {
                lastError = error
                
                // Don't retry on certain errors
                if let claudeError = error as? ClaudeAPIError {
                    switch claudeError {
                    case .missingAPIKey, .invalidResponse, .invalidIconResponse, .invalidIcon:  // Don't retry these
                        throw claudeError
                    default: // Retry other errors
                        break 
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
