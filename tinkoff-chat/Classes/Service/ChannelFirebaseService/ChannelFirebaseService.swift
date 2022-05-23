//
//  ChannelFirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import FirebaseFirestore

class ChannelFirebaseService: IChannelFirebaseService {
    
    let service: IFirebaseService
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack, firebaseService: IFirebaseService) {
        self.coreDataStack = coreDataStack
        self.service = firebaseService
    }
    
    func listeningChannels() {
        service.addSnapshotListener { result in
            switch result {
            case .success(let documents):
                documents.forEach { [weak self] documentChange in
                    let channelSnap = documentChange.document
                    let identifier = channelSnap.documentID
                    let dict = channelSnap.data()
                    
                    if let channel = Channel(identifier: identifier, dict: dict) {
                        switch documentChange.type {
                        case .added:
                            self?.coreDataStack.insertOrUpdateChannel(channel: channel)
                        case .modified:
                            self?.coreDataStack.insertOrUpdateChannel(channel: channel)
                        case .removed:
                            self?.coreDataStack.deleteChannel(channel: channel)
                        }
                    }
                }
            case .failure(let error):
                print("Fetch channels error:", error.localizedDescription)
            }
        }
    }
    
    func createChannel(name: String) {
        service.addDocument(
            data: ["name": name]
        ) { error in
            if let error = error {
                print("Channel not added:", error.localizedDescription)
            }
        }
    }
    
    func deleteChannel(channel: Channel) {
        service.deleteDocument(identifier: channel.identifier) { error in
            if let error = error {
                print("Error removing channel:", error.localizedDescription)
            }
        }
    }
}
