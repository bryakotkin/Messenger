//
//  MessagesFirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import FirebaseFirestore

class MessageFirebaseService: IMessageFirebaseService {
    
    private lazy var firebaseService = CoreAssembly.firebaseService
    private lazy var coreDataStack = ServiceAssembly.coreDataStack
    private lazy var channelsReference = firebaseService.db.collection(Constants.channels.rawValue)
    
    private func getMessageReferenceByIdentifier(_ channel: Channel) -> CollectionReference {
        return channelsReference.document(channel.identifier).collection(Constants.messages.rawValue)
    }
    
    func listeningMessages(channel: Channel?) {
        guard let channel = channel else { return }

        let messageReferance = getMessageReferenceByIdentifier(channel)
        firebaseService.collectionReference = messageReferance
        
        firebaseService.addSnapshotListener { result in
            switch result {
            case .success(let documents):
                var messages: Messages = []
                documents.forEach { [weak self] documentChange in
                    let messageSnap = documentChange.document
                    
                    if let message = Message(
                        identifier: messageSnap.documentID,
                        dict: messageSnap.data()
                    ) {
                        if documentChange.type == .added {
                            messages.append(message)
                        }
                    }
                    
                    self?.coreDataStack.insertMessages(channel: channel, messages: messages)
                }
            case .failure(let error):
                print("Fetch messages error:", error.localizedDescription)
            }
        }
    }
    
    func createMessage(channel: Channel?, _ messageText: String) {
        guard let channel = channel else { return }
        guard let deviceId = deviceId else { return }
        
        let messageReferance = getMessageReferenceByIdentifier(channel)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            let message = Message(
                identifier: "Firebase generates",
                content: messageText,
                created: Date(),
                senderId: deviceId,
                senderName: ProfileDataService.getProfileFromFile().username
            )
            
            self.firebaseService.collectionReference = messageReferance
            
            self.firebaseService.addDocument(
                data: message.toDict()
            ) { error in
                if let error = error {
                    print("Message not added:", error.localizedDescription)
                }
            }
        }
    }
}
