//
//  IProfileDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import Foundation

protocol IProfileDataService {
    static func saveProfileToFile(_ profile: Profile, flags: ProfileFlags) -> Bool
    static func getProfileFromFile() -> Profile
}
