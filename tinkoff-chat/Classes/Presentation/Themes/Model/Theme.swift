//
//  Theme.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import Foundation
import UIKit

protocol Theme {
    var labelColor: UIColor { get set }
    var labelColorOnline: UIColor { get set }
    var labelColorIncomming: UIColor { get set }
    var labelColorOutgoing: UIColor { get set }
    var backgroundColor: UIColor { get set }
    var backgroundColorOnline: UIColor { get set }
    var cloudColor: UIColor { get set }
    var cloudColorIncoming: UIColor { get set }
    var navigationBarColor: UIColor { get set }
    var titleControllerColor: UIColor { get set }
}
