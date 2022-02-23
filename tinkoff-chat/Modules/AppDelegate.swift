//
//  AppDelegate.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Logger.printAppStatus(.notrunning, .inactive, #function)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.printAppStatus(.inactive, .active, #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.printAppStatus(.active, .inactive, #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.printAppStatus(.inactive, .background, #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.printAppStatus(.background, .inactive, #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.printAppStatus(.background, .terminated, #function)
    }
}

