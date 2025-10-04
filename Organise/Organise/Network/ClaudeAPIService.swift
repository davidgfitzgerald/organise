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
        model: String = "claude-sonnet-4-20250514"
    ) async throws -> String {
        /**
         * Send a prompt to Claude and return the text response.
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
        
        // Extract the text from the response
        if let content = decodedData["content"] as? [[String: Any]],
           let firstContent = content.first,
           let text = firstContent["text"] as? String,
           !text.isEmpty {
            AppLogger.info("Response received: \(text)")
            return text
        } else {
            AppLogger.error("Failed to parse response from Claude")
            throw ClaudeAPIError.invalidResponse
        }
    }
}
