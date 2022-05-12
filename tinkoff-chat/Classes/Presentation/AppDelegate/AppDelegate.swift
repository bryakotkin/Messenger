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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        extractTheme()
        
        let conversationsListVC = PresentationAssembly.conversationsListViewController
        let navigationVC = UINavigationController(rootViewController: conversationsListVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        setupAnimatorGestureRecognizer()
        
        Logger.printAppStatus(.notrunning, .inactive, #function)
        
        return true
    }
    
    func extractTheme() {
        let themeService = ServiceAssembly.themeService
        let theme = themeService.theme
        
        themeService.saveCurrentTheme(theme ?? .classic)
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
