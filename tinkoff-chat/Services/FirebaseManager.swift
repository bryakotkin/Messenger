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
    
    func listeningChannels(completionHandler: @escaping (Channels) -> Void) {
        channelsReference.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Fetch channels error:", error.localizedDescription)
                return
            }
            
            var channels: Channels = []
            if let documents = snapshot?.documents {
                documents.forEach { channelSnap in
                    let identifier = channelSnap.documentID
                    let dict = channelSnap.data()
                    
                    if let channel = Channel(identifier: identifier, dict: dict) {
                        channels.append(channel)
                    }
                }
                
                channels = channels.sorted { channel1, channel2 in
                    guard let date1 = channel1.lastActivity else { return true }
                    guard let date2 = channel2.lastActivity else { return true }
                    
                    return date1 > date2
                }
                
                CoreDataStack.shared.saveChannels(channels: channels)
                completionHandler(channels)
            }
        }
    }
    
    func listeningMessages(channel: Channel, completionHandler: @escaping (Messages) -> Void) {
        let messageReferance = channelsReference.document(channel.identifier).collection(Constants.messages.rawValue)
        
        messageReferance.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Fetch messages error:", error.localizedDescription)
                return
            }
            
            var messages: Messages = []
            if let documents = snapshot?.documents {
                documents.forEach { messageSnap in
                    if let message = Message(dict: messageSnap.data()) {
                        messages.append(message)
                    }
                }
                
                messages = messages.sorted { message1, message2 in
                    return message1.created < message2.created
                }
                
                CoreDataStack.shared.saveMessages(channel: channel, messages: messages)
                completionHandler(messages)
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
}
