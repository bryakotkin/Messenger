//
//  Conversation.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    init?(identifier: String, dict: [String: Any]) {
        self.identifier = identifier
        
        guard let name = dict["name"] as? String else { return nil }
        self.name = name
        self.lastMessage = dict["lastMessage"] as? String
        self.lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue()
    }
}

extension Channel {
    init?(dbModel: DBChannel) {
        guard let identifier = dbModel.identifier else { return nil }
        guard let name = dbModel.name else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.lastMessage = dbModel.lastMessage
        self.lastActivity = dbModel.lastActivity
    }
}

typealias Channels = [Channel]
