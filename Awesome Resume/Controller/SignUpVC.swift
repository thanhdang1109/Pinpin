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

extension SignUpVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startActivityAnimating()
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
        startActivityAnimating()
    }
    
    func startActivityAnimating() {
        self.startAnimating(self.activityIndicatorView.frame.size, message: "Getting Location", messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: self.activityIndicatorView.color)
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
