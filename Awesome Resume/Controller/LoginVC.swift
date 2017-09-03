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
    
    @IBOutlet weak var signUpBtn: CorneredButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
//        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        
//        loginStackView.insertArrangedSubview(loginButton, at: 3)

    }
    
    
}

