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

    @IBOutlet weak var loginStackView: UIStackView!
    //    @IBOutlet weak var fbLoginBtn: FBSDKButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
//        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        
//        loginStackView.insertArrangedSubview(loginButton, at: 3)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

