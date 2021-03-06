//
//  FeedsViewController
//  Awesome Resume
//
//  Created by Hien Tran on 15/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

// TESTING PURPOSES
/*
extension FeedsViewController {
    func testingOurServerAPI(url: String, parameters: [String: String]) {
        print("---------------- TESTING --------------")
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
            .responseString { response in
            debugPrint(response)

            if let dataR = response.data {
                let json = JSON(data: dataR)
                print("JSON_TESTING: \(json)")
                print(type(of: json))
                print(json["url"])
            }
        }
    }
    
    func testAPI() {
        let parameters = [
            "type" : "user_sign_up",
            "username": "HienTran",
            "email": "heuism23892@gmail.com", //email
            "password": "awesome1234", //password
            "location": "VIC, Australia"
        ]
        let url = "http://13.66.48.219:8000/pinpin/user_sign_up/"
        testingOurServerAPI(url: url, parameters: parameters)
    }
}
*/

extension FeedsViewController {
    func getVideosFromFriends(email: String) {
        print("Registering User...")
        startActivityAnimating(message: "Getting more videos...!")
        let dataToSend = getDataToSend(type: "following_feeds", email: email)
        //        print(dataToSend)
        let myUserName = self.defaults.string(forKey: "userName")
        let url = "http://13.66.48.219:8000/pinpin/\(myUserName!)/feeds/"
        sendDataToServer(url: url, parameters: dataToSend)
    }
    
    func getDataToSend(type: String, email: String) -> [String : Any] {
        let data = [
            "type" : type,
//            "email": email
            ] as [String : Any]
        return data
    }
    
    func sendDataToServer(url: String, parameters: [String: Any]) {
        print("---------------- SENDING DATA --------------")
        print("URL is: \(url)")
        print("PARAMETER is: \(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
            .responseString { response in
//                debugPrint(response)
                switch response.result {
                case .success:
                    print("SUCCESSFUL -->")
                    if let dataR = response.data {
                        let json = JSON(data: dataR)
                        print("JSON_TESTING: \(json)")
                        print(type(of: json))
//                        print(json["url"])
                        if json["success"].boolValue {
                            self.dataArr = self.convertJSONtoData(json: json)
                            self.tableView.reloadData()
                        }
                    }
                    break
                case .failure(let error):
                    print("EREROR: -> \(error)")
                    break
                }
                self.refreshCtrl.endRefreshing()
                self.stopActivityAnimating()
        }
    }
}

extension FeedsViewController: NVActivityIndicatorViewable {
    // Just for the UIBlocker
    func startActivityAnimating(message: String) {
        self.startAnimating(CGRect(x:0,y:0,width:60,height:60).size, message: message, messageFont: nil, type: .ballScaleMultiple, color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
        //        print(currentCity)
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
    }
}

extension FeedsViewController {
    func convertJSONtoData(json: JSON) -> [(Profile, Video)] {
        var returnData = [(Profile, Video)]()
//        print("testJSON: \(json["friends"])")
        let friends = json["followings"]
        print("FriendList: \(friends)")
        for friend in friends.array! {
            print(type(of: friend))
            print(friend["email"])
            returnData.append(contentsOf: getVideoFromFriend(friend: friend))
        }
        return returnData
    }

    func getVideoFromFriend(friend: JSON) -> [(Profile, Video)] {
        var videosData = [(Profile, Video)]()
        let profile = Friend(userName: friend["username"].stringValue, email: friend["email"].stringValue, pictureUrl: nil, location: friend["location"].stringValue, followed: friend["following"].boolValue)
        let videos = friend["videos"]
        for video in videos.array! {
            print(type(of: video))
            print(video["video_description"])
            let vid = Video(title: video["title"].stringValue, description: video["description"].stringValue, time: video["date"].stringValue, link: video["link"].stringValue, filename: "")
            profile._videos?.append(vid)
            videosData.append((profile, vid))
        }
        return videosData
    }

    func testAlamofire() {
        Alamofire.request("https://httpbin.org/get").responseString { response in
            debugPrint(response)
            
            if let dataR = response.data {
                let json = JSON(data: dataR)
                print("JSON: \(json)")
                print(type(of: json))
                print(json["url"])
            }
        }
    }
}

class FeedsViewController: UITableViewController {
    
    var jsonTest: String!
    
    let defaults = UserDefaults.standard
    
    var email: String!
    
    lazy var refreshCtrl: UIRefreshControl = {
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshCtrl.tintColor = #colorLiteral(red: 0.2941176471, green: 0.5294117647, blue: 1, alpha: 1)
        refreshCtrl.attributedTitle = NSAttributedString(string: "Fetching Friends Feed Video ...")

        
        return refreshCtrl
    }()
    
    var dataArr: [(Profile, Video)] = [(Profile, Video)]()
    
    var player : VGPlayer!
    var playerView : VGEmbedPlayerView!
    var currentPlayIndexPath : IndexPath?
    var smallScreenView : UIView!
    var panGesture = UIPanGestureRecognizer()
    var playerViewSize : CGSize?
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        let responseJSON: [String: Any] = [String: Any]()
        let emailRefresh = self.email
        self.getVideosFromFriends(email: emailRefresh!)
//        VGPlayerCacheManager.shared.cleanAllCache()
//        prepData(inputJSON: responseJSON)
////        startActivityAnimating(message: "Getting more videos...!")
//
//        self.tableView.reloadData()
//        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email = self.defaults.string(forKey: "userEmail")
        jsonTest = "{ \"friends\": [{ \"user_name\": \"Hien Tran\", \"email\": \"heuism23892@gmail.com\", \"videos\": [{\"video_title\": \"Master of IT\",\"video_description\": \"Getting out of here\", \"video_date\": \"23/9/2017\", \"video_link\": \"http://www.html5videoplayer.net/videos/toystory.mp4\"}],  \"location\": \"Princes Hill, Victoria, Australia\"}] }"
        
        self.getVideosFromFriends(email: self.email)
        title = "Feeds"
        configureSmallScreenView()
        addTableViewObservers()
        self.tableView.refreshControl = self.refreshCtrl
        VGPlayerCacheManager.shared.cleanAllCache()
        
//        let responseJSON: [String: Any] = [String: Any]()
        
//        prepData(inputJSON: responseJSON)
        
        
        //        testAlamofire()
        //
        //        let data = self.jsonTest.data(using: .utf8)!
        //        let json = JSON(data: data)
        //
        //        let convertedData = convertJSONtoData(json: json)
        //
        //        print(convertedData)
        //
        //        dataArr.append(contentsOf: convertedData)
        //
        ////        testAPI()
    }
    
    func requestJSONFromServer(url: String, parameters: [String: Any]) -> Any {
        var returnData: Any?
        Alamofire.request(url).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
//            let json = JSON(data: response.data)
            // response serialization result
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//                returnData = data
//            } else {
//                returnData = ""
//            }
        }
        return returnData ?? ""
    }
    
    func prepData(inputJSON: [String: Any]) {
        let user = User(userName: "Hien Tran", email: "heuism23892@gmail.com", pictureUrl: nil, location: "Melbourne, Australia")
        print(user._videos)
        print(user._userName)
        print(user._email)
        let video = Video(title: "Dont know", description: "This is about Unimelb Desc", time: "02/09", link:
//            "http://www.html5videoplayer.net/videos/toystory.mp4"
            "https://www.dropbox.com/s/fh05vo1kxzl5ue6/ff.mp4?dl=1", filename: ""
        )
        user._videos?.append(video)
        user._videos?.append(video)
        
        print(user._videos![0]._link)
        user._friends?.append(Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil, location: "Michigan, USA", followed: false))
        print(user._friends)
        if let friends = user._friends {
            print(friends[0]._userName)
        }
        self.dataArr.append((user._friends![0], video))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let smallScreenView = smallScreenView {
            smallScreenView.removeFromSuperview()
        }
        if let playerviewCheck = playerView {
            playerView.removeFromSuperview()
        }
        if let playerCheck = player {
            player.cleanPlayer()
        }
        currentPlayIndexPath = nil
    }
    
    deinit {
        if let playerCheck = player {
            player.cleanPlayer()
        }
        removeTableViewObservers()
    }
    
    func configurePlayer() {
        playerView = VGEmbedPlayerView()
        player = VGPlayer(playerView: playerView)
        player.backgroundMode = .suspend
    }
    
    func configureSmallScreenView() {
        smallScreenView = UIView()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        smallScreenView.addGestureRecognizer(panGesture)
    }
    
    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let screenBounds = UIScreen.main.bounds
        
        var point = gesture.location(in: UIApplication.shared.keyWindow)
        if let gestureView = gesture.view {
            let width = gestureView.frame.width
            let height = gestureView.frame.height
            let distance = CGFloat(10.0)
            
            if gesture.state == .ended {
                if point.x < width/2 {
                    point.x = width/2 + distance
                } else if point.x > screenBounds.width - width/2 {
                    point.x = screenBounds.width - width/2 - distance
                }
                
                if point.y < height/2 + 64.0 {
                    point.y = height/2 + distance + 64.0
                } else if point.y > screenBounds.height - height/2 {
                    point.y = screenBounds.height - height/2 - distance
                }
                UIView.animate(withDuration: 0.5, animations: {
                    gestureView.center = point
                })
            } else {
                gestureView.center = point
            }
        }
    }
    
    var tableViewContext = 0
    func addTableViewObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        tableView?.addObserver(self, forKeyPath: #keyPath(UITableView.contentOffset), options: options, context: &tableViewContext)
    }
    
    func removeTableViewObservers() {
        tableView?.removeObserver(self, forKeyPath: #keyPath(UITableView.contentOffset))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feed_video_cell", for: indexPath) as! MediaViewCell
        let (friend, video) = dataArr[indexPath.row]
        cell.indexPath = indexPath
        cell.playCallBack = ({ [weak self] (indexPath: IndexPath?) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.playerViewSize = cell.mediaContent.bounds.size
            strongSelf.addPlayer(cell, video)
            strongSelf.currentPlayIndexPath = indexPath
        })
        cell.configCell(user: friend, media: video)
        
        return cell
    }
    
    func addPlayer(_ cell: MediaViewCell, _ video: Video) {
        if player != nil {
            player.cleanPlayer()
        }
        configurePlayer()
        cell.mediaContent.addSubview(player.displayView)
        player.displayView.snp.makeConstraints {
            $0.edges.equalTo(cell.mediaContent)
        }
        player.replaceVideo(URL(string:video._link!)!)
        player.play()
    }
    
    func addSmallScreenView() {
        player.displayView.removeFromSuperview()
        smallScreenView.removeFromSuperview()
        playerView.isSmallMode = true
        UIApplication.shared.keyWindow?.addSubview(smallScreenView)
        let smallScreenWidth = (playerViewSize?.width)! / 2
        let smallScreenHeight = (playerViewSize?.height)! / 2
        smallScreenView.snp.remakeConstraints {
            $0.bottom.equalTo(self.tableView.snp.bottom).offset(-10)
            $0.right.equalTo(self.tableView.snp.right).offset(-10)
            $0.width.equalTo(smallScreenWidth)
            $0.height.equalTo(smallScreenHeight)
        }
        smallScreenView.addSubview(player.displayView)
        player.displayView.snp.remakeConstraints {
            $0.edges.equalTo(smallScreenView)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension FeedsViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        if (context == &tableViewContext) {
        
        if keyPath == #keyPath(UITableView.contentOffset) {
            if let playIndexPath = currentPlayIndexPath {
                
                if let cell = tableView.cellForRow(at: playIndexPath) as? MediaViewCell {
                    if player.displayView.isFullScreen { return }
                    let visibleCells = tableView.visibleCells
                    if visibleCells.contains(cell) {
                        smallScreenView.removeFromSuperview()
                        cell.contentView.addSubview(player.displayView)
                        player.displayView.snp.remakeConstraints {
                            $0.edges.equalTo(cell.mediaContent)
                        }
                        playerView.isSmallMode = false
                    } else {
                        addSmallScreenView()
                    }
                } else {
                    if isViewLoaded && (view.window != nil) {
                        if smallScreenView.superview != UIApplication.shared.keyWindow {
                            addSmallScreenView()
                        }
                    }
                }
            }
        }
        //        }
    }
}


