//
//  FriendsSearchVC.swift
//  Awesome Resume
//
//  Created by Hien Tran on 22/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView

extension FriendsSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.friendListTableView.dequeueReusableCell(withIdentifier: "follow_friend_cell") as? FollowFriendCell else {
            return FollowFriendCell()
        }
        
//        let (user, video) = dataArr[indexPath.row]
        let friend = self.friendList[indexPath.row]
        
        cell.configCell(friend: friend)
        
        return cell
    }
}

extension FriendsSearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true;
        self.friendSearchBar.showsCancelButton = searchActive
        clearFriends()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        print(searchActive)
        self.friendSearchBar.endEditing(!searchActive)
        self.friendSearchBar.text = ""
        self.friendSearchBar.showsCancelButton = searchActive
        clearFriends()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false;
        self.friendSearchBar.resignFirstResponder()
        print("This is Where we call server!!!")
        print("Search Start!!")
//        self.activityIndicatorView.startAnimating()
        self.locationManager.requestLocation()
        self.fetchFriends()
//        showSpinner(uiView: self.viewIfLoaded!)
    }
    
    func clearFriends() {
        var data = [Friend]()
        self.updateFriendList(friendList: data)
    }
    
    func fetchFriends() {
        self.startAnimating(self.activityIndicatorView.frame.size, message: "Fetching", messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: self.activityIndicatorView.padding, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: self.activityIndicatorView.color)
//        self.activityIndicatorView.isHidden = false
//        self.activityIndicatorView.startAnimating()
//        self.startAnimating(self.activityIndicatorView.frame.size, message: "Testing", messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: self.activityIndicatorView.padding, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: UIColor.cyan)
        let tempFriend = Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil, location: "Michigan, USA")
        var data = [Friend]()
        data.append(tempFriend)
        data.append(tempFriend)
        self.updateFriendList(friendList: data)
        self.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
//        self.locationManager.startUpdatingLocation()
    }
}

extension FriendsSearchVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}

extension FriendsSearchVC: NVActivityIndicatorViewable {
    // Just for the UIBlocker
}

class FriendsSearchVC: UIViewController {
    let locationManager = CLLocationManager()
    
    var searchActive : Bool = false
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    var friendList:[Friend] = [Friend]()
    
    func configVC() {
        self.friendListTableView.dataSource = self
        self.friendListTableView.delegate = self
        self.friendSearchBar.delegate = self
        self.friendSearchBar.showsCancelButton = searchActive
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        self.friendListTableView.tableHeaderView = friendSearchBar
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        activityIndicatorView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
        
        friendList = (getFriendList(url: "") as? [Friend])!
        if friendList.isEmpty {
            friendListTableView.isHidden = true
        }
        else {
            friendListTableView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    func getFriendList(url: String) -> Any? {
        return []
    }
    
    func updateFriendList(friendList: [Friend]) {
        if !friendList.isEmpty {
            self.friendListTableView.isHidden = false
            self.friendList = friendList
            self.friendListTableView.reloadData()
            return
        }
        self.friendListTableView.isHidden = true
    }
    
    func updateFriendsList(url: String) {
        friendList = (getFriendList(url: url) as? [Friend])!
        if friendList.isEmpty {
            friendListTableView.isHidden = true
        }
        else {
            friendListTableView.isHidden = false
        }
        friendListTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
