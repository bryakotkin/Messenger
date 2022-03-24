//
//  GCDManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

class GCDManager: MultithreadingManager {
    func saveData(_ profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> ()) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let isSaved = ProfileDataManager.saveObjectToFile(profile, flags: flags)
            DispatchQueue.main.async {
                completionHandler(isSaved)
            }
        }
    }
    
    func getData(completionHandler: @escaping (Profile) -> ()) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let profile = ProfileDataManager.getObjectFromFile()
            DispatchQueue.main.async {
                completionHandler(profile)
            }
        }
    }
}
