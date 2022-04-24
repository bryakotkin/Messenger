//
//  IConversationModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import CoreData

protocol IConversationModel {
    var channel: Channel { get set }
    
    func createMessage(messageText: String)
    func listeningMessages()
    func getFetchController() -> NSFetchedResultsController<DBMessage>?
}
