//
//  IMessageFirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import FirebaseFirestore

protocol IMessageFirebaseService {
    func listeningMessages(channel: Channel?)
    func createMessage(channel: Channel?, _ messageText: String) 
}
