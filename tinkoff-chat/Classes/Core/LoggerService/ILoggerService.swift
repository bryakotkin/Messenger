//
//  ILoggerService.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import Foundation

protocol ILoggerService {
    static func printAppStatus(_ prev: ApplicationState, _ next: ApplicationState, _ funcName: String)
    static func printViewControllerStatus(_ funcName: String)
}
