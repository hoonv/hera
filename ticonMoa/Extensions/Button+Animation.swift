//
//  Button+Animation.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

extension UIButton {

    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func shrink() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.fromValue = 1
        animation.toValue = 0.98
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "pulse")
    }
    
    func expand() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.fromValue = 1
        animation.toValue = 1.01
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "pulse")
    }
}
