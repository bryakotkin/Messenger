//
//  ServiceAssembly.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import Foundation

class ServiceAssembly {
    static var channelService: IChannelFirebaseService {
        var firebaseService = CoreAssembly.firebaseService
        firebaseService.collectionReference = firebaseService.db.collection(Constants.channels.rawValue)

        return ChannelFirebaseService(
            coreDataStack: ServiceAssembly.coreDataStack,
            firebaseService: firebaseService
        )
    }
    
    static var messageService: IMessageFirebaseService {
        return MessageFirebaseService()
    }
    
    static var oldCoreDataService: ICoreDataService {
        return OldCoreDataService.shared
    }
    
    static var newCoreDataService: ICoreDataService {
        return NewCoreDataService.shared
    }
    
    static var coreDataStack: ICoreDataStack {
        return CoreDataStack()
    }
    
    static var gcdService: IMultithreadingService {
        return GCDService()
    }
    
    static var operationsService: IMultithreadingService {
        return OperationsService()
    }
    
    static var themeService: IThemeService {
        return ThemeService.shared
    }
    
    static var fetchControllerService: IFetchControllerService {
        return FetchContollerService()
    }
    
    static var networkConfigFactory: NetworkConfigFactory {
        return NetworkConfigFactory()
    }
}
