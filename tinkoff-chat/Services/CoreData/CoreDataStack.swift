//
//  CoreDataStack.swift
//  tinkoff-chat
//
//  Created by Nikita on 07.04.2022.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    let service = NewCoreDataService()
    
    private init() {}
    
    func enableObservers() {
        service.enableObservers()
    }
    
    func fetchChannelByIdentifier(_ channel: Channel) -> DBChannel? {
        let format = "\(#keyPath(DBChannel.identifier)) == %@"
        let predicate = NSPredicate(format: format, channel.identifier)
        let dbChannels: [DBChannel] = service.readData(
            predicate: predicate,
            context: service.writeContext
        )
        
        return dbChannels.first
    }
    
    func fetchMessageByIdentifier(_ message: Message) -> DBMessage? {
        let format = "\(#keyPath(DBMessage.identifier)) == %@"
        let predicate = NSPredicate(format: format, message.identifier)
        let dbMessages: [DBMessage] = service.readData(
            predicate: predicate,
            context: service.writeContext
        )
        
        return dbMessages.first
    }
    
    func insertOrUpdateChannel(channel: Channel) {
        let dbChannel = fetchChannelByIdentifier(channel)
        
        if let dbChannel = dbChannel {
            service.performSave { _ in
                dbChannel.identifier = channel.identifier
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
            }
        } else {
            service.performSave { context in
                let dbChannel = DBChannel(context: context)
                dbChannel.identifier = channel.identifier
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
            }
        }
    }
    
    func deleteChannel(channel: Channel) {
        let dbChannel = fetchChannelByIdentifier(channel)
        guard let dbChannel = dbChannel else { return }

        service.deleteData(model: dbChannel)
    }
    
    func insertMessage(channel: Channel, message: Message) {
        guard fetchMessageByIdentifier(message) == nil else { return }
        guard let dbChannel = fetchChannelByIdentifier(channel) else { return }
        
        service.performSave { context in
            let dbMessage = DBMessage(context: context)
            dbMessage.identifier = message.identifier
            dbMessage.content = message.content
            dbMessage.created = message.created
            dbMessage.senderId = message.senderId
            dbMessage.senderName = message.senderName
            
            dbChannel.addToMessages(dbMessage)
        }
    }
}
