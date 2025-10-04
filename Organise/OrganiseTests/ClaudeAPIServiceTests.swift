//
//  ClaudeAPIServiceTests.swift
//  OrganiseTests
//
//  Created by David Fitzgerald on 11/06/2025.
//

import Testing
@testable import Organise

@Test func claudeAPIKeyIsSet() {
    let apiKey = ClaudeAPIService.claudeAPIKey
    #expect(!apiKey.isEmpty, "Claude API key should not be empty")
}

@Test func claudeAPIServiceReturnsResponse() async throws {
    let testPrompt = "Say 'Hello, World!' and nothing else."
    let response = try await ClaudeAPIService.prompt(content: testPrompt, maxTokens: 10)
    
    #expect(!response.isEmpty, "Claude API should return a non-empty response")
    #expect(response.contains("Hello") || response.contains("hello"), "Response should contain expected content")
}
