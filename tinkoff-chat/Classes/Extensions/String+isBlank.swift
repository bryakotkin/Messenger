//
//  String+isBlank.swift
//  tinkoff-chat
//
//  Created by Nikita on 30.03.2022.
//

import Foundation

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
