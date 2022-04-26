//
//  Constants.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import Foundation
import UIKit

enum Constants: String {
    case conversationListCell
    case conversationCell
    case imagePickerCell
    case profileUsername
    case profileDescription
    case profileImage
    case channels
    case messages
}

let deviceId = UIDevice.current.identifierForVendor?.uuidString
