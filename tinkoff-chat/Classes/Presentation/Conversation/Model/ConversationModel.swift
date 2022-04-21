//
//  ConversationModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import Foundation
import CoreData

class ConversationModel: IConversationModel {
    
    var channel: Channel
    
    let messageService: IMessageFirebaseService
    let fetchControllerService: IFetchControllerService
    
    init(messageService: IMessageFirebaseService, fetchControllerService: IFetchControllerService, channel: Channel) {
        self.channel = channel
        self.messageService = messageService
        self.fetchControllerService = fetchControllerService
    }
    
    func createMessage(messageText: String) {
        messageService.createMessage(channel: channel, messageText)
    }
    
    func listeningMessages() {
        messageService.listeningMessages(channel: channel)
    }
    
    func getFetchController() -> NSFetchedResultsController<DBMessage>? {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)
        ]
        
        let format = #keyPath(DBMessage.channel.identifier) + " == %@"
        let predicate = NSPredicate(format: format, channel.identifier)
        
        let controller: NSFetchedResultsController<DBMessage>? = fetchControllerService.createFetchController(
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
        
        return controller
    }
}
