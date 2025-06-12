//
//  ClaudeAPIService.swift
//  Organise
//
//  Created by David Fitzgerald on 11/06/2025.
//

import Foundation

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

    static func suggestEmoji(for name: String) async throws -> String {
        var request = URLRequest(url: messagesEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue(claudeAPIKey, forHTTPHeaderField: "x-api-key")
        
        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 10, // TODO: just 1?
            "messages": [
                [
                    "role": "user",
                    "content": "Suggest the best emoji for depicting \(name). Reply with only the single emoji character."
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        print("Making request to: \(messagesEndpoint.absoluteString)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedData = try JSONSerialization.jsonObject(with: data) as! [String : Any]
        
        print("Got \(decodedData) back from Claude.")
        
        // Extract the emoji from the response
        if let content = decodedData["content"] as? [[String: Any]],
           let firstContent = content.first,
           let text = firstContent["text"] as? String {
            
            print("Emoji received: \(text)")
            return text
        } else {
            print("Failed to parse emoji from response")
            return "❓" // fallback emoji
        }
    }
}
