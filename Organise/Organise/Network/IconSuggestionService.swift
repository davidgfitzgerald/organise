//
//  IconSuggestionService.swift
//  Organise
//
//  Created by David Fitzgerald on 11/06/2025.
//

import Foundation

enum IconSuggestionError: LocalizedError {
    case invalidIconResponse
    case invalidIcon
    
    var errorDescription: String? {
        switch self {
        case .invalidIconResponse:
            return "Failed to generate icon. Using default icon instead."
        case .invalidIcon:
            return "Invalid icon received from API. Using default icon instead."
        }
    }
}

struct IconSuggestionService {
    
    static func validateIcon(_ string: String) -> String {
        guard !string.isEmpty else { return "questionmark.app.fill" }
        
        // If it's a valid icon, return it
        if string.isValidSFSymbol {
            return string
        }
        
        // If not valid, return a fallback icon
        return "questionmark.app.fill"
    }
    
    static func suggestIcon(for name: String) async throws -> String {
        do {
            let response = try await ClaudeAPIService.prompt(
                content: "Suggest the best SF Symbol string for depicting \(name). Favour SF Symbols that appear happier, more positive, cleaner, more fun, productive, exciting, etc. Reply with ONLY the single SF Symbol string your response is being used in an API call so must match precisely (e.g. you would reply something like 'drop.fill')."
            )
            
            AppLogger.info("Response received: \(response)")
            
            // Validate the icon
            let validatedIcon = validateIcon(response)
            
            AppLogger.info("Validated icon: \(validatedIcon)")
            return validatedIcon
            
        } catch let error as ClaudeAPIError {
            // Re-throw Claude API errors
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
                    case .missingAPIKey, .invalidResponse:  // Don't retry these
                        throw claudeError
                    default: // Retry other errors
                        break 
                    }
                }
                
                // Wait before retry (exponential backoff)
                if attempt < maxRetries {
                    let delay = Double(attempt) * 1.0 // 1s, 2s delays
//                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    // TODO UNCOMMENT - Task now conflicts with created thing called Task
                }
            }
        }
        
        // If we get here, all retries failed
        throw lastError ?? ClaudeAPIError.networkError(NSError(domain: "Unknown", code: -1))
    }
}
