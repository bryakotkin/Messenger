//
//  ConversationModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import Foundation

struct ConversationModel {
    var name: String?
    var messages: Messages?
    var online: Bool?
    var hasUnreadMessages: Bool?
}

struct Message {
    var text: String?
    var date: Date?
    var isIncoming: Bool?
}

typealias Messages = [Message]
