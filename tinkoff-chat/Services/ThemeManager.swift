//
//  ThemeManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation

class ThemeManager {
    
    static let shared: ThemeManager = ThemeManager()
    
    private let defaults = UserDefaults.standard
    
    var theme: Themes? {
        get {
            guard let rawValue = defaults.string(forKey: #function) else { return nil }
            
            return Themes(rawValue: rawValue)
        }
        set {
            defaults.set(newValue?.rawValue, forKey: #function)
        }
    }
    
    var currentTheme: Theme?
    
    private init() {}
    
    func saveCurrentTheme(_ theme: Themes) {
        self.theme = theme
        
        switch theme {
        case .classic:
            currentTheme = ClassicTheme()
        case .day:
            currentTheme = DayTheme()
        case .night:
            currentTheme = NightTheme()
        }
    }
}