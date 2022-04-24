//
//  ConversationsListModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import CoreData

class ConversationListModel: IConversationsListModel {
    
    let channelService: IChannelFirebaseService
    let themeService: IThemeService
    
    init(channelService: IChannelFirebaseService, themeService: IThemeService) {
        self.channelService = channelService
        self.themeService = themeService
    }
    
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
        
        let fetchService = ServiceAssembly.fetchControllerService
        let controller: NSFetchedResultsController<DBChannel>? = fetchService.createFetchController(
            sortDescriptors: sortDescriptors,
            predicate: nil
        )
            
        return controller
    }
    
    func saveTheme(_ theme: Themes) {
        themeService.saveCurrentTheme(theme)
    }
    
    func getTheme() -> Theme? {
        themeService.currentTheme
    }
}
