//
//  IProfileModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import Foundation

protocol IProfileModel {
    func updateConcurrencyService(_ service: IMultithreadingService)
    func fetchProfileData(_ completionHandler: @escaping (Profile) -> Void)
    func saveProfileData(profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> Void)
}
