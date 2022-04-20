//
//  ConversationsListModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import CoreData

class ConversationListModel {
    
    let channelService = ServiceAssembly.channelService
    let themeService = ServiceAssembly.themeService
    
    func listeningChannels() {
        channelService.listeningChannels()
    }
    
    func createChannel(name: String) {
        channelService.createChannel(name: name)
    }
    
    func deleteChannel(channel: Channel) {
        channelService.deleteChannel(channel: channel)
    }
    
    func getFetchController() -> NSFetchedResultsController<DBChannel>? {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
        ]
        
        let fetchService = CoreAssembly.fetchControllerService
        let controller: NSFetchedResultsController<DBChannel>? = fetchService.createFetchController(
            sortDescriptors: sortDescriptors,
            predicate: nil
        )
            
        return controller
    }
}
