//
//  UIView+Nib.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

extension UIView {
    
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
