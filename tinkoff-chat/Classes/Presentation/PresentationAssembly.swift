//
//  PresentationAssembly.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import Foundation

class PresentationAssembly {

    static var conversationsListViewController: ConversationsListViewController {
        let channelService = ServiceAssembly.channelService
        let themeService = ServiceAssembly.themeService
        
        let model = ConversationListModel(channelService: channelService,
                                          themeService: themeService)
        let conversationList = ConversationsListViewController(model)
        
        return conversationList
    }
    
    static var profileViewController: ProfileViewController {
        let service = ServiceAssembly.gcdService
        
        let model = ProfileModel(concurrencyService: service)
        let profileController = ProfileViewController(model: model)
        
        return profileController
    }
    
    static var pixabayImagePickerViewController: PixabayImagePickerViewController {
        let service = CoreAssembly.requestService
        let factory = ServiceAssembly.networkConfigFactory
        
        let model = PixabayImagePickerModel(requestService: service,
                                            networkFactory: factory)
        let controller = PixabayImagePickerViewController(model: model)
        
        return controller
    }
    
    static var themeViewController: ThemesViewController {
        return ThemesViewController()
    }
    
    static func getConversationViewController(channel: Channel) -> ConversationViewController {
        let fetchService = ServiceAssembly.fetchControllerService
        let messageService = ServiceAssembly.messageService
        
        let model = ConversationModel(messageService: messageService,
                                      fetchControllerService: fetchService,
                                      channel: channel)
        let controller = ConversationViewController(model: model)
        
        return controller
    }
}
