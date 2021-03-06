//
//  TouchableUIView.swift
//  Awesome Resume
//
//  Created by Hien Tran on 3/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

extension UIResponder {
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}

class TouchableUIView: UIView {
    
    var canClick: Bool = true
    var firstPoint: CGPoint? = nil
    var secondPoint: CGPoint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
//            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
            firstPoint = touch.location(in: self)
//            secondPoint = touch.location(in: self)
        }
        let children = self.subviews
        for child in children {
            child.alpha = 0.5
        }
//        self.alpha = 0.5
        canClick = true
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            firstPoint = touch.location(in: self)
//            if self.frame.contains(firstPoint!) {
//                let children = self.subviews
//                for child in children {
//                    child.alpha = 0.5
//                }
//                canClick = true
//            }
//            else {
//                let children = self.subviews
//                for child in children {
//                    child.alpha = 1.0
//                }
//                canClick = false
//            }
//        }
//        if let touch = touches.first {
//            let currentPoint = touch.location(in: self)
//            // do something with your currentPoint
//        }
//
//        let children = self.subviews
//        for child in children {
//            child.alpha = 0.5
//        }
        //        self.alpha = 0.5
        canClick = true
//        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
//        self.alpha = 0.5
        let children = self.subviews
        if let touch = touches.first {
            if (hitTest(touch.location(in: self), with: event) != nil) {
                print("Touch passed hit test and seems valid")
                super.touchesCancelled(touches, with: event)
                for child in children {
                                child.alpha = 0.5
                            }
                self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
                canClick = true
                return
            }
        }
        
        for child in children {
            child.alpha = 1.0
        }
        canClick = false
        print("Touch isn't passed hit test and will be ignored")
        super.touchesMoved(touches, with: event)
        
        self.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3803921569, blue: 0.6117647059, alpha: 1)//Color when UIView is clicked.
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.bounds.contains(self.convert(point, from: self)) {
            return self
        }
        return nil
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
        if canClick {
            if let accessToken = AccessToken.current {
                // User is logged in, use 'accessToken' here.
                print("Already In ----- >")
//                logoutBtnClicked()
            } else {
//                loginBtnClicked()
            }
        }
    }
    
//    func loginBtnClicked() {
//        let loginManager = LoginManager()
//        loginManager.logIn([ ReadPermission.publicProfile ], viewController: self.getParentViewController()) { loginResult in
//            switch loginResult {
//                case .failed(let err):
//                    print(err)
//            case .cancelled:
//                print("User cancelled login")
//            case .success(let grantedPermissions, let declinedPermissions, let token):
//                print("Success!")
//                print("\(grantedPermissions) + \(declinedPermissions) + \(token)")
//                let loginVC = self.getParentViewController() as! LoginVC!
//                loginVC?.updateStatus(loginResult: "Logged In")
//            }
//        }
//    }
    
//    func logoutBtnClicked() {
//        let loginManager = LoginManager()
//        loginManager.logOut()
//        let loginVC = self.getParentViewController() as! LoginVC!
//        loginVC?.updateStatus(loginResult: "Logged Out")
//    }
}
