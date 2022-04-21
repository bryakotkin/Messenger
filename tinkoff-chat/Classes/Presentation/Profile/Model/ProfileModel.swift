//
//  ProfileModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import Foundation

class ProfileModel: IProfileModel {
    
    var concurrencyService: IMultithreadingService
    
    init(concurrencyService: IMultithreadingService) {
        self.concurrencyService = concurrencyService
    }
    
    func updateConcurrencyService(_ service: IMultithreadingService) {
        self.concurrencyService = service
    }
    
    func fetchProfileData(_ completionHandler: @escaping (Profile) -> Void) {
        concurrencyService.getData(completionHandler: completionHandler)
    }
    
    func saveProfileData(profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> Void) {
        concurrencyService.saveData(profile, flags: flags, completionHandler: completionHandler)
    }
}
