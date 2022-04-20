//
//  IChannelFirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import Foundation

protocol IChannelFirebaseService {
    func listeningChannels()
    func createChannel(name: String)
    func deleteChannel(channel: Channel)
}
