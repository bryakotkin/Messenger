//
//  DataSourceManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import Foundation

class ConversationsDataManager {
    
    static func getConversations() -> [[Conversation]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        var messages1 = Messages()
        
        messages1.append(
            Message(text: "Привет, как дела?",
                    date: dateFormatter.date(from: "2021-12-04 00:00"),
                    isIncoming: true)
        )
        
        messages1.append(
            Message(text: "Хорошо, где ты сейчас учишься?",
                    date: dateFormatter.date(from: "2021-12-05 14:15"),
                    isIncoming: false)
        )
        
        messages1.append(
            Message(text: "Обучаюсь в \"Тинькофф Финтех\"",
                    date: dateFormatter.date(from: "2021-12-05 14:16"),
                    isIncoming: true)
        )
        
        messages1.append(
            Message(text: "Круто!!!",
                    date: Date(),
                    isIncoming: false)
        )
        
        var messages2 = messages1
        messages2.removeLast()
        
        var conversations: [[Conversation]] = [[], []]
        // swiftlint:disable:next line_length
        let names = ["Cаша А", "Никита А", "Коля A", "Максим А", "Иван A", "Егор А", "Юля А", "Оля А", "Артем А", "Георгий А", "Эдуард А", "Cаша Б", "Никита Б", "Коля Б", "Максим Б", "Иван Б", "Егор Б", "Юля Б", "Оля Б", "Артем Б", "Георгий Б"]
        var isOnline = true
        
        for (i, element) in names.enumerated() {
            let index = isOnline ? 0 : 1
            let messages = isOnline ? messages1 : messages2
            if i % 2 == 0 {
                conversations[index].append(Conversation(name: element, messages: messages, online: isOnline, hasUnreadMessages: isOnline))
            } else {
                conversations[index].append(Conversation(name: element, messages: nil, online: isOnline, hasUnreadMessages: !isOnline))
                isOnline = !isOnline
            }
        }
        
        return conversations
    }
}
