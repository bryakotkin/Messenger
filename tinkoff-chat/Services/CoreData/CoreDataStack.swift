//
//  CoreDataStack.swift
//  tinkoff-chat
//
//  Created by Nikita on 07.04.2022.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    let service: OldCoreDataService = OldCoreDataService.shared
    
    func enableObservers() {
        service.enableObservers()
    }
    
    func fetchDBChannel(channel: Channel) -> DBChannel? {
        let dbChannels: [DBChannel] = service.readData()
        
        guard let dbChannel = dbChannels.filter({ dbModel in
            dbModel.identifier == channel.identifier
        }).first else {
            return nil
        }
        
        return dbChannel
    }
    
    func fetchChannels() -> Channels {
        let dbChannels: [DBChannel] = service.readData()
        var channels: Channels = []
        
        dbChannels.forEach { dbModel in
            let channel = Channel(dbModel: dbModel)
            channels.append(channel)
        }
        
        channels = channels.sorted { channel1, channel2 in
            guard let date1 = channel1.lastActivity else { return true }
            guard let date2 = channel2.lastActivity else { return true }
            
            return date1 > date2
        }
        
        return channels
    }
    
    func fetchMessages(channel: Channel) -> Messages {
        guard let dbChannel = fetchDBChannel(channel: channel) else { return [] }
        guard let dbMessages = dbChannel.messages?.allObjects as? [DBMessage] else { return [] }
        
        var messages: Messages = []
        
        dbMessages.forEach { dbModel in
            let message = Message(dbModel: dbModel)
            messages.append(message)
        }
        
        messages = messages.sorted { message1, message2 in
            return message1.created < message2.created
        }
        
        return messages
    }
    
    func saveChannels(channels: Channels) {
        service.performSave { context in
            channels.forEach { channel in
                let dbChannel = DBChannel(context: context)
                dbChannel.identifier = channel.identifier
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
            }
        }
    }
    
    func saveMessages(channel: Channel, messages: Messages) {
        service.performSave { context in
            let dbChannel = DBChannel(context: context)
            dbChannel.identifier = channel.identifier
            dbChannel.name = channel.name
            dbChannel.lastMessage = channel.lastMessage
            dbChannel.lastActivity = channel.lastActivity
            
            var dbMessages: [DBMessage] = []
            messages.forEach { message in
                let dbMessage = DBMessage(context: context)
                dbMessage.content = message.content
                dbMessage.created = message.created
                dbMessage.senderId = message.senderId
                dbMessage.senderName = message.senderName
                
                dbMessages.append(dbMessage)
            }
            
            dbMessages.forEach { dbMessage in
                dbChannel.addToMessages(dbMessage)
            }
        }
    }
}
