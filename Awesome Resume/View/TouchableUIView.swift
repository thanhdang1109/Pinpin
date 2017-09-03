//
//  TouchableUIView.swift
//  Awesome Resume
//
//  Created by Hien Tran on 3/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class TouchableUIView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
        let children = self.subviews
        for child in children {
            child.alpha = 0.5
        }
//        self.alpha = 0.5
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
        let children = self.subviews
        for child in children {
            child.alpha = 0.5
        }
//        self.alpha = 0.5
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
        let children = self.subviews
        for child in children {
            child.alpha = 1.0
        }
        self.alpha = 1.0
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
    }

}
