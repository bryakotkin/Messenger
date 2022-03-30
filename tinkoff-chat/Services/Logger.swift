//
//  Logger.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.02.2022.
//

import Foundation

class Logger {

    enum ApplicationState: String {
        case notrunning
        case inactive
        case active
        case background
        case terminated
    }
    
    static func printAppStatus(_ prev: ApplicationState, _ next: ApplicationState, _ funcName: String) {
        if ProcessInfo.processInfo.environment["logger"] == "show" {
            print("Application moved from \(prev) to \(next): \(funcName)")
        }
    }
    
    static func printViewControllerStatus(_ funcName: String) {
        if ProcessInfo.processInfo.environment["logger"] == "show" {
            print(funcName)
        }
    }
}
