//
//  AppDelegate+Animator.swift
//  tinkoff-chat
//
//  Created by Nikita on 06.05.2022.
//

import UIKit

extension AppDelegate {
    func setupAnimatorGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                             action: #selector(animateView))
        window?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func animateView(_ sender: UIGestureRecognizer) {
        guard let rootView = UIViewController.topViewController()?.view else { return }
        let currentLocation = sender.location(in: window)
        
        let subView = AnimatorService.subview
        
        switch sender.state {
        case .began:
            subView.center = currentLocation
            rootView.addSubview(subView)
            AnimatorService.startAnimation()
        case .changed:
            subView.center = currentLocation
        case .ended:
            AnimatorService.stopAnimation()
        @unknown default:
            AnimatorService.stopAnimation()
        }
    }
}
