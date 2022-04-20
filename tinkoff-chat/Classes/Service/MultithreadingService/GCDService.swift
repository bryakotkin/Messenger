//
//  GCDManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

class GCDService: IMultithreadingService {
    func saveData(_ profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let isSaved = ProfileDataService.saveProfileToFile(profile, flags: flags)
            DispatchQueue.main.async {
                completionHandler(isSaved)
            }
        }
    }
    
    func getData(completionHandler: @escaping (Profile) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let profile = ProfileDataService.getProfileFromFile()
            DispatchQueue.main.async {
                completionHandler(profile)
            }
        }
    }
}
