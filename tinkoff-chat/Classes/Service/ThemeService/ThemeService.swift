//
//  ThemeManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation

enum ThemeType: String {
    case classic
    case day
    case night
    
    func getTheme() -> Theme {
        switch self {
        case .classic: return ClassicTheme()
        case .day: return DayTheme()
        case .night: return NightTheme()
        }
    }
}

class ThemeService: IThemeService {
    
    private let defaults = UserDefaults.standard
    
    var theme: Theme? {
        get {
            return themeType?.getTheme()
        }
        set {
            themeType = newValue?.themeType
        }
    }
    
    private var themeType: ThemeType? {
        get {
            guard let rawValue = defaults.string(forKey: #function) else { return nil }
            return ThemeType(rawValue: rawValue)
        }
        set {
            defaults.set(newValue?.rawValue, forKey: #function)
        }
    }
}
