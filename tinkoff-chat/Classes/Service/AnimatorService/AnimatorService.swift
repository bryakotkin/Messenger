//
//  AnimatorService.swift
//  tinkoff-chat
//
//  Created by Nikita on 06.05.2022.
//

import UIKit

class AnimatorService {
    
    static var subview: UIView = {
        let view = UIView()
        let width = UIScreen.main.bounds.width / 4
        let size = CGSize(width: width, height: width)
        view.frame.size = size
        return view
    }()
    
    static let image = UIImage(named: "small-logo")
    
    static var imageView: UIImageView {
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        
        return view
    }
    
    static func getRandomCoordinate(from location: CGPoint) -> CGPoint {
        let range = UIScreen.main.bounds.width / 4
        let randomRangeX = CGFloat.random(in: 0...range)
        let randomRangeY = CGFloat.random(in: 0...range)
        
        let locationX = location.x
        let locationY = location.y
        
        let randomX = Int.random(in: 0...1) == 0 ? locationX + randomRangeX : locationX - randomRangeX
        let randomY = Int.random(in: 0...1) == 0 ? locationY + randomRangeY : locationY - randomRangeY
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    private static func createSubviews() -> [UIView] {
        var subviews = [UIView]()
        
        for _ in 0 ..< 10 {
            let imageView = imageView
            imageView.center = CGPoint(x: subview.bounds.midX, y: subview.bounds.midY)
            subview.addSubview(imageView)
            subviews.append(imageView)
        }
        
        return subviews
    }
    
    static func startAnimation() {
        let subviews = createSubviews()
        
        subviews.forEach { view in
            animate(view: view)
        }
    }
    
    static func stopAnimation() {
        subview.removeSubviews()
        subview.removeFromSuperview()
    }
    
    static func animate(view: UIView) {
        let centerAnimateDuration = Double.random(in: 0...1)
        let relativeDuration = 1 - centerAnimateDuration
        let prevTransform = view.transform
        
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0.0,
            options: [.allowUserInteraction, .repeat]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 1.0) {
                view.center = getRandomCoordinate(from: view.center)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75,
                               relativeDuration: 0.25) {
                view.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.0) {
                let randomAngle = Double.random(in: 0...2 * Double.pi)
                view.transform = CGAffineTransform(rotationAngle: randomAngle)
            }
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: centerAnimateDuration) {
                let randomScale = CGFloat.random(in: 1...2)
                view.transform = CGAffineTransform(scaleX: randomScale, y: randomScale)
            }
            UIView.addKeyframe(withRelativeStartTime: centerAnimateDuration,
                               relativeDuration: relativeDuration) {
                view.transform = prevTransform
            }
        }
    }
}
