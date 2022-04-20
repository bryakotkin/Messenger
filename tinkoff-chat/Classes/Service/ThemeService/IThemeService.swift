//
//  IThemeService.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import Foundation

protocol IThemeService {
    static var shared: IThemeService { get }
    var theme: Themes? { get set }
    var currentTheme: Theme? { get set }
    
    func saveCurrentTheme(_ theme: Themes)
}
