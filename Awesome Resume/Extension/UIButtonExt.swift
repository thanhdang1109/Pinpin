//
//  UIButtonExt.swift
//  Awesome Resume
//
//  Created by Hien Tran on 29/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func wiggle() {
        let wiggleAnim = CABasicAnimation(keyPath: "position")
        wiggleAnim.duration = 0.05
        wiggleAnim.repeatCount = 5
        wiggleAnim.autoreverses = true
        wiggleAnim.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        wiggleAnim.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        self.layer.add(wiggleAnim, forKey: "position")
    }
    
    func dim() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0.75
        }) { (finished) in UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 1.0
        })
        }
    }
}
