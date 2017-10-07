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
import SwiftyJSON

extension FriendsSearchVC {
    func storeDataToUserDefault(key: String, data: Any) {
        self.defaults.set(data, forKey: key)
    }
}

extension FriendsSearchVC: FriendDelegate {
    func followFriendExecute(friendUserName: String, friendEmail: String, index: Int) {
//        let email = self.defaults.string(forKey: "userEmail")
        print("Following Friend...")
        if let userName = self.defaults.string(forKey: "userName") {
            followFriend(email: userName, friend_user_name: friendUserName, friend_email: friendEmail, index: index)
        }
    }
    
    func unfollowFriendExecute(friendUserName: String, friendEmail: String, index: Int) {
        print("Unfollowing Friend...")
        if let userName = self.defaults.string(forKey: "userName") {
            unfollowFriend(email: userName, friend_user_name: friendUserName, friend_email: friendEmail, index: index)
        }
    }
}

extension FriendsSearchVC {
    
    func unfollowFriend(email: String, friend_user_name: String, friend_email: String, index: Int) {
        print("Unfollow User...")
        startActivityAnimating(message: "Unfollowing \(friend_user_name)...")
        let dataToSend = getDataToSend(type: "unfollowing", email: email, friend_email: friend_email ,friend_user_name: friend_user_name, city: "", index: index)
        //        print(dataToSend)
        let url = "http://13.66.48.219:8000/pinpin/\(friend_user_name)/unfollowing/"
        sendDataToServer(url: url, parameters: dataToSend)
    }
    
    func followFriend(email: String, friend_user_name: String, friend_email: String, index: Int) {
        print("Follow User...")
        startActivityAnimating(message: "Following \(friend_user_name)...")
        let dataToSend = getDataToSend(type: "new_following", email: email, friend_email: friend_email ,friend_user_name: friend_user_name, city: "", index: index)
        //        print(dataToSend)
        let url = "http://13.66.48.219:8000/pinpin/\(friend_user_name)/new_following/"
        sendDataToServer(url: url, parameters: dataToSend)
    }
    
    func fetchFriendWithLocation(email: String, friend_user_name: String, location: String) {
        print("Fetching User...")
//        startActivityAnimating(message: "Fetching Friends Near You...")
//        self.locationManager.requestLocation()
//        while self.location == nil {
//            print(".")
//        }
//        print(self.location!)
        let dataToSend = getDataToSend(type: "find_users_in_location", email: email, friend_email: "",friend_user_name: friend_user_name, city: location, index: 0)
        //        print(dataToSend)
        let url = "http://13.66.48.219:8000/pinpin/\(location)/users/"
        print("URL is : \(url)")
        sendDataToServer(url: url, parameters: dataToSend)
    }
    
    func getDataToSend(type: String, email: String, friend_email: String, friend_user_name: String, city: String, index: Int) -> [String : Any] {
        var data: [String: Any] = [String: Any]()
        data["type"] = type
//        data["username_request"] = email
        switch type {
        case "find_users_in_location":
//                let locationArr = (currLoc.replacingOccurrences(of: " ", with: "")).split(separator: ",")
//                print("Location Array = \(locationArr)")
                data["city"] = city
            break
        case "unfollowing":
            data["unfollowing_username"] = friend_user_name
            data["unfollowing_index"] = index
            break
        default:
            data["following_username"] = friend_user_name
            data["following_index"] = index
//            data["friend_email"] = friend_email
        }
//        let data = [
//            "type" : type,
//            "email": email, //email
//            "city": locationArr[0],
//            "state": locationArr[1],
//            "country": locationArr[2]
//            ] as [String : Any]
        return data
    }
    
    func sendDataToServer(url: String, parameters: [String: Any]) {
        print("---------------- SENDING DATA --------------")
        print("PARAMETERS IS: \(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
            .responseString { response in
//                debugPrint(response)
                switch response.result {
                case .success:
                    print("SUCCESSFUL: -> /*\(response)*/")
                    if let dataR = response.data {
                        let json = JSON(data: dataR)
                        print("JSON_TESTING: \(json)")
                        print(type(of: json))
                        print(json["url"])
                        switch json["type"].stringValue {
                            case "find_users_in_location":
                                self.caseLookUp(json: json)
                                break
//                            case "follow_user":
//                                self.caseFollow(json: json)
//                                break
                            case "new_following":
                                    self.caseFollow(json: json)
                                break
                            case "unfollowing":
                                    self.caseFollow(json: json)
                                break
                            default:
//                                self.caseFollow(json: json)
                                break
                        }
                    }
                    break
                case .failure(let error):
//                    sender.wiggle()
                    print("EREROR: -> \(error)")
                    break
                }
                self.fetchingFriend = false
                self.stopActivityAnimating()
        }
    }
}

extension FriendsSearchVC {
    func caseLookUp(json: JSON) {
        let friendData = getFriendList(json: json)
        updateFriendList(friendList: friendData)
    }
    
    func caseFollow(json: JSON) {
        let friendData = followFriendUpdate(json: json)
        updateFriendList(friendList: friendData)
    }
    
    func getFriendList(json: JSON) -> [Friend] {
        var returnData = [Friend]()
//        let city = json["city"].stringValue
//        let state = json["state"].stringValue
//        let country = json["country"].stringValue
//
//        let location = "\(city) \(state) \(country)"
        
        let users = json["users"]
        print("Users List: \(users)")
        for user in users.array! {
            print(type(of: user))
            print(user["email"])
            returnData.append(contentsOf: getUser(user: user))
        }
        return returnData
    }
    
    func getUser(user: JSON) -> [Friend] {
        let profile = Friend(userName: user["username"].stringValue, email: user["email"].stringValue, pictureUrl: nil, location: user["location"].stringValue, followed: user["following"].boolValue)
        return [profile]
    }
    
    func followFriendUpdate(json: JSON) -> [Friend] {
        if let index = json["following_index"].int {
            self.friendList[index]._followed = json["success"].boolValue
            return self.friendList
        }
        self.friendList[json["unfollowing_index"].intValue]._followed = json["success"].boolValue
        return self.friendList
    }
}

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
        
        cell.index = indexPath.row
        cell.friendDelegate = self
        
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
        print("This is Where we call server -> Getting Friends!!!")
        print("Search Start!!")
        print("Looking for friend: \(searchBar.text!)")
        if searchBar.text != nil {
            self.fetchingFriend = true
            self.fetchFriendWithLocation(email: self.userName, friend_user_name: self.friendSearchBar.text!, location: searchBar.text!)
            startActivityAnimating(message: "Fetching Friends Near You...")
            //        self.fetchFriendWithLocation(email: self.email, friend_user_name: searchBar.text!)
            //        self.activityIndicatorView.startAnimating()
//            self.locationManager.requestLocation()
        } else {
            self.fetchingFriend = false
        }
//        self.fetchFriends()
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
        let tempFriend = Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil, location: "Michigan, USA", followed: false)
        var data = [Friend]()
        data.append(tempFriend)
        data.append(tempFriend)
        self.updateFriendList(friendList: data)
        self.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.location = nil
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
                self.friendSearchBar.text = locality
                self.stopActivityAnimating()
                self.location = "\(locality), \(administrativeArea), \(country)"
//                print(self.fetchingFriend)
//                if self.fetchingFriend {
//                    print("HERE!!!!")
//                    self.fetchFriendWithLocation(email: self.email, friend_user_name: self.friendSearchBar.text!, location: self.location!)
//                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}

extension FriendsSearchVC: NVActivityIndicatorViewable {
    // Just for the UIBlocker
    func startActivityAnimating(message: String) {
        self.startAnimating(self.activityIndicatorView.frame.size, message: message, messageFont: nil, type: self.activityIndicatorView.type, color: self.activityIndicatorView.color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: self.activityIndicatorView.color)
        //        print(currentCity)
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
    }
}

class FriendsSearchVC: UIViewController {
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var email: String!
    var userName: String!
    var location: String?
    
    var searchActive : Bool = false
    var fetchingFriend: Bool = false
    
    @IBOutlet weak var fetchCurrLocation: UIButton!
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    var friendList:[Friend] = [Friend]()
    
    func configVC() {
        email = defaults.string(forKey: "userEmail")
        userName = defaults.string(forKey: "userName")
        
        self.friendListTableView.dataSource = self
        self.friendListTableView.delegate = self
        self.friendSearchBar.delegate = self
        self.friendSearchBar.showsCancelButton = searchActive
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        self.friendListTableView.tableHeaderView = friendSearchBar
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        activityIndicatorView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
        let defaults = UserDefaults.standard
//        print(defaults.string(forKey: "user_email"))
//        print(defaults.string(forKey: "user_pass"))
//        friendList = (getFriendList(url: "") as? [Friend])!
//        friendList = fetchFriendWithLocation
        friendList = []
        if friendList.isEmpty {
            friendListTableView.isHidden = true
        }
        else {
            friendListTableView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
//    func getFriendList(url: String) -> Any? {
//        return []
//    }
    
    func updateFriendList(friendList: [Friend]) {
        if !friendList.isEmpty {
            self.friendListTableView.isHidden = false
            self.friendList = friendList
            self.friendListTableView.reloadData()
            return
        }
        self.friendListTableView.isHidden = true
    }
    
    @IBAction func getCurrLocation(_ sender: Any) {
        self.startActivityAnimating(message: "Getting your location...!")
        self.locationManager.requestLocation()
    }
    //    func updateFriendsList(url: String) {
//        friendList = (getFriendList(url: url) as? [Friend])!
//        if friendList.isEmpty {
//            friendListTableView.isHidden = true
//        }
//        else {
//            friendListTableView.isHidden = false
//        }
//        friendListTableView.reloadData()
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
