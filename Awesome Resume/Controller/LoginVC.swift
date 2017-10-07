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
import NVActivityIndicatorView
import SwiftyJSON

extension LoginVC {
//    func gotoTabBar() {
//        let secondViewController = self.storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as VideoViewController
//        self.navigationController.pushViewController(secondViewController, animated: true)
//    }
    
    func storeDataToUserDefault(key: String, data: Any) {
        self.defaults.set(data, forKey: key)
    }
    
    func loginUser(email: String, password: String, sender: UIButton) {
        print("Login User...")
        startActivityAnimating(message: "Login User...")
        let dataToSend = getDataToSend(type: "user_login", email: email, password: password)
        //        print(dataToSend)
        let url = "http://13.66.48.219:8000/user_login/"
        sendDataToServer(url: url, parameters: dataToSend, sender: sender)
    }
    
    func getDataToSend(type: String, email: String, password: String) -> [String : Any] {
        let data = [
            "type" : type,
            "email": email, //email
            "password": password, //password
        ]
        return data
    }
    
    func sendDataToServer(url: String, parameters: [String: Any], sender: UIButton) {
        print("---------------- SENDING DATA --------------")
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
            .responseString { response in
                debugPrint(response)
                switch response.result {
                                case .success:
                                    print("SUCCESSFUL: -> \(response)")
                                    if let dataR = response.data {
                                        let json = JSON(data: dataR)
                                        print("JSON_TESTING: \(json)")
                                        print(type(of: json))
                                        print(json["url"])
                                        if json["success"].boolValue {
                                            let email = json["email"].string
                                            let userName = json["username"].string
                                            self.storeDataToUserDefault(key: "userEmail", data: email)
                                            self.storeDataToUserDefault(key: "userName", data: userName)
                                            self.performSegue(withIdentifier: "loginSuccess", sender: self)
                                        } else {
                                            sender.wiggle()
                                        }
                                    }
                                    break
                                case .failure(let error):
                                    sender.wiggle()
                                    print("EREROR: -> \(error)")
                                    break
                                }
                self.stopActivityAnimating()
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension LoginVC: NVActivityIndicatorViewable {
    
}

class LoginVC: UIViewController {

    @IBOutlet weak var appImg: UIImageView!
    
    @IBOutlet weak var loginStackView: UIStackView!
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPassField: UITextField!
    //    @IBOutlet weak var fbLoginBtn: FBSDKButton!
    @IBOutlet weak var normalSignInBtn: CorneredButton!
    @IBOutlet weak var fbSignInBtn: TouchableUIView!
    @IBOutlet weak var fbBtnLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var signUpBtn: CorneredButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
    }
    
    func configVC() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        userEmailField.delegate = self
        userPassField.delegate = self
        userEmailField.text = "claude@gmail.com"
        userPassField.text = "helloworld"
        
        print(self.defaults.string(forKey: "user_email"))
        print(self.defaults.string(forKey: "user_pass"))
        
    }
    
    func updateStatus(loginResult: String) {
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("Success ----->")
            fbBtnLbl.text = "Sign Out"
        } else {
            fbBtnLbl.text = "Sign In with Facebook"
        }
    }
    
    func normalLogin(email: String, pass: String, btn: UIButton) {
        loginUser(email: email, password: pass, sender: btn)
    }
    
    func startActivityAnimating(message: String) {
        self.startAnimating(self.activityIndicatorView.frame.size, message: message, messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: self.activityIndicatorView.color)
        //        print(currentCity)
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
    }
    
    @IBAction func normalSignInBtnPressed(_ sender: Any) {
        let btn = sender as! UIButton
//        let userEmailVal = userEmailField.text
//        let userPassVal = userPassField.text
//        performSegue(withIdentifier: "loginSuccess", sender: self)
        if let userEmailVal = userEmailField.text, let userPassVal = userPassField.text {
            if isValidEmail(email: userEmailVal) {
//                self.defaults.set(userEmailVal, forKey: "user_email")
//                self.defaults.set(userPassVal, forKey: "user_pass")
                normalLogin(email: userEmailVal, pass: userPassVal, btn: btn)
                return
            }
//            self.defaults.set(userEmailVal, forKey: "user_email")
            btn.wiggle()
            return
        }
        btn.wiggle()
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

