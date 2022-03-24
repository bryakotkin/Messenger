//
//  Message.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.03.2022.
//

import Foundation

struct Message {
    var text: String?
    var date: Date?
    var isIncoming: Bool?
}

typealias Messages = [Message]
