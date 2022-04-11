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
    var senderId: String?
    var senderName: String?
}

extension Message {
    init?(dict: [String: Any]) {
        guard let content = dict["content"] as? String else { return nil }
        guard let created = (dict["created"] as? Timestamp)?.dateValue() else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = dict["senderID"] as? String
        self.senderName = dict["senderName"] as? String
    }
}

extension Message {
    init(dbModel: DBMessage) {
        self.content = dbModel.content ?? ""
        self.created = dbModel.created ?? Date()
        self.senderId = dbModel.senderId
        self.senderName = dbModel.senderName
    }
}

extension Message {
    func toDict() -> [String: Any] {
        return [
            "content": content,
            "created": Timestamp(date: created),
            "senderID": senderId ?? "",
            "senderName": senderName ?? ""
        ]
    }
}

typealias Messages = [Message]
