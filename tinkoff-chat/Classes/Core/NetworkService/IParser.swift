//
//  IParser.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
