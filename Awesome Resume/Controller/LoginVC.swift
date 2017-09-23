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
import FBSDKLoginKit
import Alamofire

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
//        let fbLoginBtn = FBSDKLoginButton()
//        loginStackView.insertArrangedSubview(fbLoginBtn, at: 3)
        
//        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        
//        loginStackView.insertArrangedSubview(loginButton, at: 3)
//        loginButton.frame.size.height = 60
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
    
    func normalLogin(email: String, pass: String) {
        let parameters = [
            "email": email, //email
            "password": pass //password
        ]
    
//        var statusCode: Int = 0
//        Alamofire.request(.POST, "http://{dreamfactoryinstance}/api/v2/user/session", parameters: parameters, encoding: .JSON)
//            .responseJSON { response in
//                statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
//                if let value: AnyObject = response.result.value {
//                    //Handle the results as JSON
//                    let post = JSON(value)
//                    if let key = post["session_id"].string {
//                        //At this point the user should have authenticated, store the session id and use it as you wish
//                    } else {
//                        print("error detected")
//                    }
//                }
//        }
    }
    
    @IBAction func normalSignInBtnPressed(_ sender: Any) {
//        let userEmailVal = userEmailField.text
//        let userPassVal = userPassField.text
        if let userEmailVal = userEmailField.text, let userPassVal = userPassField.text {
            normalLogin(email: userEmailVal, pass: userPassVal)
        }
    }
    
}

