//
//  ICoreDataStack.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import CoreData

protocol ICoreDataStack {
    var service: ICoreDataService { get }
    
    func insertOrUpdateChannel(channel: Channel)
    func deleteChannel(channel: Channel)
    func insertMessage(dbChannel: DBChannel, message: Message, context: NSManagedObjectContext)
    func insertMessages(channel: Channel, messages: Messages)
}
