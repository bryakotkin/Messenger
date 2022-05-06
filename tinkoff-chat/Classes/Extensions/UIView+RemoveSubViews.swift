//
//  UIView+RemoveSubViews.swift
//  tinkoff-chat
//
//  Created by Nikita on 06.05.2022.
//

import UIKit

extension UIView {
    func removeSubviews() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
