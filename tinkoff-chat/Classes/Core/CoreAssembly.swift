//
//  CoreAssembly.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import Foundation

class CoreAssembly {
    static var firebaseService: IFirebaseService {
        return FirebaseService()
    }
    
    static var storageService: IStorageService {
        return StorageService()
    }
    
    static var requestService: IRequestSender {
        return RequestSender()
    }
}
