//
//  Message.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.03.2022.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    var senderName: String
}

extension Message {
    init?(dict: [String: Any]) {
        guard let content = dict["content"] as? String else { return nil }
        guard let created = (dict["created"] as? Timestamp)?.dateValue() else { return nil }
        guard let senderId = dict["senderID"] as? String else { return nil }
        guard let senderName = dict["senderName"] as? String else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}

extension Message {
    func toDict() -> [String: Any] {
        return [
            "content": content,
            "created": Timestamp(date: created),
            "senderID": senderId,
            "senderName": senderName
        ]
    }
}

typealias Messages = [Message]
