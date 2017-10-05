//
//  SignUpVCViewController.swift
//  Awesome Resume
//
//  Created by Hien Tran on 4/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

extension SignUpVC {
    func signUserUp(userName: String, email: String, password: String, currentLocation: String, sender: UIButton) {
        print("Registering User...")
        startActivityAnimating(message: "Registering User...")
        let dataToSend = getDataToSend(type: "new_user_signup", username: userName, email: email, password: password, currLoc: currentLocation)
//        print(dataToSend)
        let url = "http://13.66.48.219:8000/pinpin/user_sign_up/"
        sendDataToServer(url: url, parameters: dataToSend, sender: sender)
    }
    
    func getDataToSend(type: String, username: String, email: String, password: String, currLoc: String) -> [String : Any] {
        let locationArr = (currLoc.replacingOccurrences(of: " ", with: "")).split(separator: ",")
        print("Location Array = \(locationArr)")
        let data = [
            "type" : type,
            "username": username,
            "email": email, //email
            "password": password, //password
//            "location": currLoc
            "city": locationArr[0],
            "state": locationArr[1],
            "country": locationArr[2]
            ] as [String : Any]
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
                            self.dismiss(animated: true, completion: nil)
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

extension SignUpVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startActivityAnimating(message: "Getting Location...!")
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            if let locality = placemark.locality, let postalCode = placemark.postalCode, let administrativeArea = placemark.administrativeArea, let country = placemark.country {
                print(locality)
                print(postalCode)
                print(administrativeArea)
                print(country)
                fetchLocation(city: locality, state: administrativeArea, country: country)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SignUpVC: NVActivityIndicatorViewable {
    // Just for the UIBlocker
}

class SignUpVC: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userCurrentLocationBtn: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    
    let locationManager = CLLocationManager()
    
    var currentCity = ""
    var currentCountry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configVC()
    }
    
    func configVC() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        userName.delegate = self
        userEmail.delegate = self
        userPassword.delegate = self
        userConfirmPassword.delegate = self
        userLocation.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func getUserCurrentLocation(_ sender: Any) {
        self.locationManager.requestLocation()
        startActivityAnimating(message: "Getting Location...!")
    }
    
    func startActivityAnimating(message: String) {
        self.startAnimating(self.activityIndicatorView.frame.size, message: message, messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: self.activityIndicatorView.color)
        //        print(currentCity)
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
    }
    
    func fetchLocation(city: String, state: String, country: String) {
        userLocation.text = "\(city), \(state), \(country)"
        stopActivityAnimating()
    }
    
    @IBAction func cancelSignUpPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerBtnPressed(_ sender: Any) {
        let btn = sender as! UIButton
        if let name = userName.text, let email = userEmail.text, let pass = userPassword.text, let passConfirm = userConfirmPassword.text, let loc = userLocation.text {
            if !pass.isEmpty && pass == passConfirm && !loc.isEmpty && isValidEmail(email: email) //&& isLowerCased(userName: name)
            {
                self.signUserUp(userName: name, email: email, password: pass, currentLocation: loc, sender: btn)
//                self.sendRegisterMsg()
                return
            }
            else {
                btn.wiggle()
                return
            }
        }
        btn.wiggle()
    }
    
//    func sendRegisterMsg() {
//        print("Registering User...")
//        // If success
//        dismiss(animated: true, completion: nil)
//        //else
//    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isLowerCased(userName: String) -> Bool {
        let userNameRegEx = "[0-9a-z_-]+"
        print("USERNAME:-->\(userName)")
        let userNameTest = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
        print(userNameTest.evaluate(with: userNameRegEx))
        return userNameTest.evaluate(with: userNameRegEx)
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
