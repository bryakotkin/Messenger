//
//  CoreDataStack.swift
//  tinkoff-chat
//
//  Created by Nikita on 07.04.2022.
//

import CoreData

class CoreDataStack: ICoreDataStack {
    
    var service = ServiceAssembly.newCoreDataService
    
    private func fetchChannelByIdentifier(_ channel: Channel) -> DBChannel? {
        let format = "\(#keyPath(DBChannel.identifier)) == %@"
        let predicate = NSPredicate(format: format, channel.identifier)
        let dbChannels: [DBChannel] = service.readData(
            predicate: predicate,
            context: service.writeContext
        )
        
        return dbChannels.first
    }
    
    private func fetchMessageByIdentifier(_ message: Message) -> DBMessage? {
        let format = "\(#keyPath(DBMessage.identifier)) == %@"
        let predicate = NSPredicate(format: format, message.identifier)
        let dbMessages: [DBMessage] = service.readData(
            predicate: predicate,
            context: service.writeContext
        )
        
        return dbMessages.first
    }
    
    func insertOrUpdateChannel(channel: Channel) {
        let dbChannel = fetchChannelByIdentifier(channel) // тут exaption
        
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
    
    func insertMessage(dbChannel: DBChannel, message: Message, context: NSManagedObjectContext) {
        guard fetchMessageByIdentifier(message) == nil else { return }
        
        let dbMessage = DBMessage(context: context)
        dbMessage.identifier = message.identifier
        dbMessage.content = message.content
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        dbMessage.senderName = message.senderName
            
        dbChannel.addToMessages(dbMessage)
    }
    
    func insertMessages(channel: Channel, messages: Messages) {
        guard !messages.isEmpty else { return }
        guard let dbChannel = fetchChannelByIdentifier(channel) else { return }
        
        service.performSave { [weak self] context in
            messages.forEach { message in
                self?.insertMessage(dbChannel: dbChannel, message: message, context: context)
            }
        }
    }
}
