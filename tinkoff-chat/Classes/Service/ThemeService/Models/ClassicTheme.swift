//
//  ClassTheme.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation
import UIKit

class ClassicTheme: Theme {
    var themeType: ThemeType = .classic
    var labelColor: UIColor = .black
    var labelColorOnline: UIColor = .black
    var labelColorIncomming: UIColor = .black
    var labelColorOutgoing: UIColor = .black
    var backgroundColor: UIColor = .white
    var backgroundColorOnline: UIColor = CustomColors.lightYellow
    var cloudColor: UIColor = CustomColors.lightGreen
    var cloudColorIncoming: UIColor = CustomColors.lightGrey2
    var navigationBarColor: UIColor = .white
    var titleControllerColor: UIColor = .black
}
