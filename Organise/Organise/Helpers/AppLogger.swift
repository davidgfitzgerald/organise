//
//  AppLogger.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//

import Foundation

import os

struct AppLogger {
    static func error(_ message: String) {
        print("🔴 ERROR: \(message)")
    }
    
    static func warning(_ message: String) {
        print("⚠️ WARNING: \(message)")
    }
    
    static func info(_ message: String) {
        print("ℹ️ INFO: \(message)")
    }
    
    static func success(_ message: String) {
        print("✅ SUCCESS: \(message)")
    }
    
    static func debug(_ message: String) {
        print("🐛 DEBUG: \(message)")
    }
}
