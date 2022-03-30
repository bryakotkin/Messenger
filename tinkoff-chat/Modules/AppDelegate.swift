//
//  AppDelegate.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firebaseManager: FirebaseManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        firebaseManager = FirebaseManager()
        
        extractTheme()
        
        let conversationsListVC = ConversationsListViewController()
        let navigationVC = UINavigationController(rootViewController: conversationsListVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        Logger.printAppStatus(.notrunning, .inactive, #function)
        
        return true
    }
    
    func extractTheme() {
        if let theme = ThemeManager.shared.theme {
            ThemeManager.shared.saveCurrentTheme(theme)
        } else {
            ThemeManager.shared.saveCurrentTheme(.classic)
        }
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
