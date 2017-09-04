//
//  ViewController.swift
//  Awesome Resume
//
//  Created by Hien Tran on 3/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginVC: UIViewController {

    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var loginStackView: UIStackView!
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPassField: UITextField!
    //    @IBOutlet weak var fbLoginBtn: FBSDKButton!
    @IBOutlet weak var normalSignInBtn: CorneredButton!
    @IBOutlet weak var fbSignInBtn: TouchableUIView!
    @IBOutlet weak var fbBtnLbl: UILabel!
    
    @IBOutlet weak var signUpBtn: CorneredButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        
        loginStackView.insertArrangedSubview(loginButton, at: 3)
//        if let accessToken = AccessToken.current {
//            // User is logged in, use 'accessToken' here.
//            print("Success")
//        }

    }
    
    func updateStatus(loginResult: String) {
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("Success ----- >")
            fbBtnLbl.text = "Sign Out"
        } else {
            fbBtnLbl.text = "Sign In with Facebook"
        }
    }
    
    
}

