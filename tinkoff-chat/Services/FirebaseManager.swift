//
//  FirestoreManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 28.03.2022.
//

import Foundation
import FirebaseFirestore
import UIKit

class FirebaseManager {
    
    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection(Constants.channels.rawValue)
    
    func listeningChannels() {
        channelsReference.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Fetch channels error:", error.localizedDescription)
                return
            }
            
            if let documents = snapshot?.documentChanges {
                documents.forEach { documentChange in
                    let channelSnap = documentChange.document
                    let identifier = channelSnap.documentID
                    let dict = channelSnap.data()
                    
                    if let channel = Channel(identifier: identifier, dict: dict) {
                        switch documentChange.type {
                        case .added:
                            CoreDataStack.shared.insertOrUpdateChannel(channel: channel)
                        case .modified:
                            CoreDataStack.shared.insertOrUpdateChannel(channel: channel)
                        case .removed:
                            CoreDataStack.shared.deleteChannel(channel: channel)
                        }
                    }
                }
            }
        }
    }
    
    func listeningMessages(channel: Channel?) {
        guard let channel = channel else { return }
        let messageReferance = channelsReference.document(channel.identifier).collection(Constants.messages.rawValue)
        
        messageReferance.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Fetch messages error:", error.localizedDescription)
                return
            }
            
            if let documents = snapshot?.documentChanges {
                documents.forEach { documentChange in
                    let messageSnap = documentChange.document
                    
                    if let message = Message(
                        identifier: messageSnap.documentID,
                        dict: messageSnap.data()
                    ) {
                        if documentChange.type == .added {
                            CoreDataStack.shared.insertMessage(channel: channel, message: message)
                        }
                    }
                }
            }
        }
    }
    
    func createChannel(name: String) {
        channelsReference.addDocument(
            data: ["name": name]
        ) { error in
            if let error = error {
                print("Channel not added:", error.localizedDescription)
            }
        }
    }
    
    func createMessage(channel: Channel, _ messageText: String) {
        guard let deviceId = deviceId else { return }
        let messageReferance = channelsReference.document(channel.identifier).collection(Constants.messages.rawValue)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let message = Message(
                identifier: "Firebase generates",
                content: messageText,
                created: Date(),
                senderId: deviceId,
                senderName: ProfileDataManager.getObjectFromFile().username
            )
            
            messageReferance.addDocument(
                data: message.toDict()
            ) { error in
                if let error = error {
                    print("Message not added:", error.localizedDescription)
                }
            }
        }
    }
    
    func deleteChannel(channel: Channel) {
        channelsReference.document(channel.identifier).delete { error in
            if let error = error {
                print("Error removing channel:", error.localizedDescription)
            }
        }
    }
}
