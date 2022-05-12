//
//  UIViewController+TopViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 06.05.2022.
//

import UIKit

extension UIViewController {
    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
