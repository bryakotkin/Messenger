//
//  Message.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.03.2022.
//

import Foundation
import Firebase

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String?
    let senderName: String?
}

extension Message {
    init?(identifier: String, dict: [String: Any]) {
        guard let content = dict["content"] as? String else { return nil }
        guard let created = (dict["created"] as? Timestamp)?.dateValue() else { return nil }
        
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = dict["senderID"] as? String
        self.senderName = dict["senderName"] as? String
    }
}

extension Message {
    init?(dbModel: DBMessage) {
        guard let identifier = dbModel.identifier else { return nil }
        guard let content = dbModel.content else { return nil }
        guard let created = dbModel.created else { return nil }
        
        self.identifier = identifier
        self.content = content
        self.created = created
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
