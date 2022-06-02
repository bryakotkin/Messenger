//
//  Theme.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation
import UIKit

protocol Theme {
    var themeType: ThemeType { get }
    var labelColor: UIColor { get }
    var labelColorOnline: UIColor { get }
    var labelColorIncomming: UIColor { get }
    var labelColorOutgoing: UIColor { get }
    var backgroundColor: UIColor { get }
    var backgroundColorOnline: UIColor { get }
    var cloudColor: UIColor { get }
    var cloudColorIncoming: UIColor { get }
    var navigationBarColor: UIColor { get }
    var titleControllerColor: UIColor { get }
}
