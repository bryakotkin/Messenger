//
//  DayTheme.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation
import UIKit

class DayTheme: Theme {
    var themeType: ThemeType = .day
    var labelColor: UIColor = .black
    var labelColorOnline: UIColor = .black
    var labelColorIncomming: UIColor = .black
    var labelColorOutgoing: UIColor = .white
    var backgroundColor: UIColor = CustomColors.cyan
    var backgroundColorOnline: UIColor = CustomColors.lightBlue2
    var cloudColor: UIColor = CustomColors.darkBlue2
    var cloudColorIncoming: UIColor = CustomColors.lightGrey2
    var navigationBarColor: UIColor = .cyan
    var titleControllerColor: UIColor = .black
}
