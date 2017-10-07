//
//  VideosViewController.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 30/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit
import Alamofire
import SwiftyJSON
import AZSClient
import NVActivityIndicatorView

class VideosViewController: UITableViewController, SaveDataDelegate {
    
    // MARK: Variabels
    
    // If using Shared Key access, fill in your credentials here and un-comment the "UsingSAS" line:
    var connectionString: String!
    var containerName: String!
    var dataArr: [Video] = [
//        Video(title: "Claude Chen", description: "2 Cobden st. North Melbourne, 3051 VIC", time: "", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
//        Video(title: "University of Melbourne", description: "Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology", time: "2016-2018", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
//        Video(title: "UESTC", description: "Bachalor of Computer Science and Technology", time: "", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
//        Video(title: "UESTC--2", description: "Bachalor of Computer Science and Technology", time: "", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
    ]
    var player : VGPlayer!
    var playerView : VGEmbedPlayerView!
    var currentPlayIndexPath : IndexPath?
    var smallScreenView : UIView!
    var panGesture = UIPanGestureRecognizer()
    var playerViewSize : CGSize?
    
    let defaults = UserDefaults.standard
    
    
    ////////////////////////////////////////
    ///
    /// VIEWDIDLOAD HANDLES
    ///
    ////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.connectionString = "DefaultEndpointsProtocol=https;AccountName=cs1ea921f0a44b4x43fbxa0e;AccountKey=B41efiZWKDOt8Gxi0ku/MrHJJoiM7Aal0JA71dJJG0Nx6GNtkQ8fHZZdi8YnD/rwlaXtbejv18ZSm/DceRSGlw=="
        
        self.containerName = self.defaults.string(forKey: "userName")
        
        print("User Name: \(self.containerName)")
        print("User Email: " + self.defaults.string(forKey: "userEmail")!)
        
        requestTableViewData()
        

        self.navigationItem.title = "My Resume"
        
//        configureSmallScreenView()
        
        self.tableView.refreshControl = self.refreshCtrl // Adding refresh control
        self.tableView.reloadData()
    }
    

    
    func removeVideo(video: Video, index: Int){
        
        let blobLink = video._link!
        let blobName = blobLink.split(separator: "/").last!
        
        print ("Deleting Blob \(blobName)")
        
        // Create a semaphore to prevent the method from exiting before all of the async operations finish.
        // -- In most real applications, you wouldn't do this, it makes this whole series of operations synchronous.
        let semaphore = DispatchSemaphore(value: 0)
        // Create a storage account object from a connection string.
        let account = try? AZSCloudStorageAccount(fromConnectionString: self.connectionString)
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient? = account?.getBlobClient()
        // Create a local container object with a unique name.
        let blobContainer: AZSCloudBlobContainer? = blobClient?.containerReference(fromName: self.containerName!)
        // Create the container on the service and check to see if there was an error.
        let blockBlob: AZSCloudBlockBlob? = blobContainer?.blockBlobReference(fromName: String(blobName))
        
        blockBlob?.delete(completionHandler: { (_ error: Error?) -> Void in
            if error != nil {
                print("[!] Error in deleting blob.\n --> \(error!)")
                let successAlert = UIAlertController.init(title: "Delete Failed!", message: "", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
                self.stopActivityAnimating()
                return
            }
            print(":: Delete Successfully!")
//            let successAlert = UIAlertController.init(title: "Upload Successfully!", message: "", preferredStyle: .alert)
//            successAlert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
//            self.present(successAlert, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.dataArr.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.reloadData()
                self.stopActivityAnimating()
            }

            semaphore.signal()
        })
        
    }
    
    func uploadVideo(fileName: String, filePath: String, video: Video) {

        ////////////////////////////////////
        ///
        /// Azure Blob Files Handles
        /// Uploading Videos.
        ///
        ////////////////////////////////////
        
        // Create a semaphore to prevent the method from exiting before all of the async operations finish.
        // -- In most real applications, you wouldn't do this, it makes this whole series of operations synchronous.
        let semaphore = DispatchSemaphore(value: 0)
        // Create a storage account object from a connection string.
        let account = try? AZSCloudStorageAccount(fromConnectionString: self.connectionString)
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient? = account?.getBlobClient()
        // Create a local container object with a unique name.
        let blobContainer: AZSCloudBlobContainer? = blobClient?.containerReference(fromName: self.containerName!)
        // Create the container on the service and check to see if there was an error.
        let blockBlob: AZSCloudBlockBlob? = blobContainer?.blockBlobReference(fromName: fileName)
        blockBlob?.properties.contentType = "video/mp4"
        
        let onlineLink = "https://cs1ea921f0a44b4x43fbxa0e.blob.core.windows.net/\(self.containerName!)/\(fileName)"
        
        // Check if Container (name with the username) exists
        // If not, create!
        
        blobContainer?.exists(completionHandler: { (_ error: Error?, isExist: Bool) in
            if isExist == false{
                blobContainer?.createContainer(completionHandler: { (_ error: Error?) in
                    print(":: Container Not Exist, New Container Created!")
                })
            }
            else {
                print ("Start Uploading the \(filePath)")
                blockBlob?.upload(from: InputStream.init(fileAtPath: filePath)!, completionHandler: { (_ error: Error?) in
                    if error != nil {
                        print("Error in uploading blob.\n --> \(error!)")
                        
                        print(":: Upload Failed!")
                        let successAlert = UIAlertController.init(title: "Upload Failed!", message: "", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                        self.present(successAlert, animated: true, completion: nil)
                        
                        return
                    }
                    print(":: Upload Successfully!")
                    let successAlert = UIAlertController.init(title: "Upload Successfully!", message: "", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                    self.present(successAlert, animated: true, completion: nil)
                    
                    print ("Upload Successfully!")
                    video._link = onlineLink // Update the link
                    
                    self.requestSaveNewVideo(video: video)
                    
                    self.stopActivityAnimating()
                    semaphore.signal()
                })
            }
        })

        
        
//        blockBlob?.upload(fromText: "JJJJJ", completionHandler: { (_ error: Error?) in
//            if error != nil {
//                print("Error in uploading blob.\(error)")
//                return
//            }
//            print ("Upload Successfully!")
//            semaphore.signal()
//        })
//
//        
//        blobContainer?.createContainer(completionHandler: {(_ error: Error?) -> Void in
//            if error != nil {
//                print("Error in creating container.\(error!)")
//                return
//            }
//            // Create a local blob object
//            let blockBlob: AZSCloudBlockBlob? = blobContainer?.blockBlobReference(fromName: "blockBlob")
//            // Get some sample text for the blob
//            let blobText = "Claude Chen"
//            // Upload the text to the blob.
//            blockBlob?.upload(fromText: blobText, completionHandler: {(_ error: Error?) -> Void in
//                if error != nil {
//                    print("Error in uploading blob.\(error)")
//                    return
//                }
//                // Download the blob's contents to a new text string.
//                blockBlob?.downloadToText(completionHandler: {(_ error: Error?, _ resultText: String?) -> Void in
//                    if error != nil {
//                        print("Error in downloading blob.\(error)")
//                        return
//                    }
//                    // Validate that the uploaded/downloaded string is correct.
//                    if !(blobText == resultText) {
//                        print("Error - the text in the blob does not match.\(error)")
//                        return
//                    }
//                    // Delete the container from the service.
//                    blobContainer?.delete(completionHandler: { (_ error: Error?) in
//                        if error != nil {
//                            print("Error in deleting container.\(error)")
//                            return
//                        }
//                        semaphore.signal()
////                    })
//                })
//            })
//        })
        
        semaphore.wait(timeout: .distantFuture)
        // Pause the method until the above operations complete.
    }

    
    lazy var refreshCtrl: UIRefreshControl = {
        /// Action when activating the refresh controll
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.5327750428)
        refreshCtrl.addTarget(self,
                              action: #selector(self.handleRefresh(_:)),
                              for: UIControlEvents.valueChanged)
        refreshCtrl.tintColor = #colorLiteral(red: 0.7764705882, green: 0.07450980392, blue: 0.04705882353, alpha: 1)
        clearTmpDirectory()
        return refreshCtrl
    }()
    
    func clearTmpDirectory() {
        ///
        /// After confirmation of saving video, all temp videos should be removed
        ///
        let tmpDirectory = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
        for file: String in tmpDirectory! {
            try? FileManager.default.removeItem(atPath: "\(NSTemporaryDirectory())\(file)")
        }
        print ("Temp Files Removed!")
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        VGPlayerCacheManager.shared.cleanAllCache()
        requestTableViewData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        // Overwrite the viewWillDisappear
        //
        
        super.viewWillDisappear(animated)
        if let playerviewCheck = playerView {
            playerView.removeFromSuperview()
            VGPlayerCacheManager.shared.cleanAllCache()
        }
        if let playerCheck = player {
            player.cleanPlayer()
            VGPlayerCacheManager.shared.cleanAllCache()
        }
        currentPlayIndexPath = nil
    }
    
//    deinit {
//        if let playerCheck = player {
//            player.cleanPlayer()
//        }
//        removeTableViewObservers()
//    }
    

    
    func configureSmallScreenView() {
        
        smallScreenView = UIView()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        smallScreenView.addGestureRecognizer(panGesture)
    }
    
    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        ///
        ///
        ///
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
    
    ///////////////////////////
    ///
    /// Table View Handles
    ///
    ///////////////////////////
    
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
        ///
        /// [Override Tableview Function] cellForRowAt
        ///
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoMediaTableCell", for: indexPath) as! VideoMediaTableCell
        let video = dataArr[indexPath.row]
        cell.indexPath = indexPath
        cell.playCallBack = ({ [weak self] (indexPath: IndexPath?) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.playerViewSize = cell.mediaContent.bounds.size
            strongSelf.addPlayer(cell, video)
            strongSelf.currentPlayIndexPath = indexPath
        })
        cell.configCell(media: video)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 345
    }
    
    // Enable tableview to reorder the cell
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = self.dataArr[sourceIndexPath.row]
        self.dataArr.remove(at: sourceIndexPath.row)
        self.dataArr.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.startActivityAnimating(message: "Deleting Video...")
            let video2delete = self.dataArr[indexPath.row]
            requestDeleteVideo(video: video2delete, index: indexPath.row)
//            removeVideo(video: video2delete, index: indexPath.row)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        })
        deleteButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        
        return [deleteButton]
    }
    
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(player.displayView.superview)
        if player != nil && player.displayView.isDescendant(of: cell){
            player.cleanPlayer()
            player.displayView.removeFromSuperview()
        }
    }
    
    
    //////////////////////////////
    ///
    /// Video Players Handles
    ///
    //////////////////////////////
    
    func addPlayer(_ cell: VideoMediaTableCell, _ video: Video) {
        /// -----------------------------
        ///
        /// Adding Player
        ///
        /// -----------------------------
        if player != nil {
            player.cleanPlayer()
        }
        configurePlayer()
        
        cell.mediaContent.addSubview(player.displayView)
        player.displayView.snp.makeConstraints {
            $0.edges.equalTo(cell.mediaContent)
        }
        
        let path = URL(string:video._link!)!
        print(path)
        player.replaceVideo(path)
        
        
        player.play()
    }
    
    func configurePlayer() {
        ///
        /// Configure the the player
        ///
        
        playerView = VGEmbedPlayerView()
        playerView.panGesture.isEnabled = false
        player = VGPlayer(playerView: playerView)
        player.backgroundMode = .suspend
    }
    
    func addSmallScreenView() {
        ///
        /// Small Video Floating Window
        ///
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
    
    
    ///
    ///  Loading Animation
    ///
    
    func startActivityAnimating(message: String) {
        self.startAnimating(CGRect(x:0,y:0,width:60,height:60).size, message: message, messageFont: nil, type: .ballScaleMultiple, color: #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1))
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
    }
    
    ///  ---------------   Loading Animation
    
    func saveBtnPressed(data: Video){
        ///
        /// Save Data Delegate Function
        ///
        print (data._fileName!)
        print (data._link!)
        startActivityAnimating(message: "Uploading Video ...")
        let onlineLink = uploadVideo(fileName: data._fileName!, filePath: data._link!, video: data) // UPLOADING VIDE
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSegue"{
            let vc: VideosEditViewController = segue.destination as! VideosEditViewController
            vc.saveDataDelegate = self
        }
    }
}

extension VideosViewController {

    func convertJSONtoData(jsonData: JSON) -> [Video] {
        var returnData = [Video]()
        print(jsonData.array)
        for videoItem in jsonData.array![0].array!{
            var vid = Video(title: videoItem["title"].stringValue,
                              description: videoItem["description"].stringValue,
                              time: videoItem["date"].stringValue,
                              link: videoItem["link"].stringValue,
                              filename: "")
            vid._videoId = videoItem["id"].intValue
            returnData.append(vid)
        }
        return returnData
    }
    
    func requestToServer(videoIndex: Int?, videoData: Video?, url: String, parameters: [String: Any], mode: String) {
        /// Request Function to the Server
        print("---------------- TESTING ---------------")
        switch mode {
        case "requestTableViewData":
            ///
            /// Request for User's Videos
            ///
            Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
                .responseString { response in
//                    debugPrint(response)
                    /// receive the response
                    switch response.result {
                    case .success:
                        print("SUCCESSFUL:")
                        if let dataR = response.data {
                            let json = JSON(data: dataR)
                            print("JSON_TESTING: \(json)")
                            print(type(of: json))
                            print(json["url"])
                            if json["success"].boolValue {
                                self.dataArr = self.convertJSONtoData(jsonData: json["videos"] )
                                self.tableView.reloadData()
                            }else{
                                self.dataArr = []
                                self.tableView.reloadData()
                            }
                        }
                        break
                    case .failure(let error):
                        print("EREROR: -> \(error)")
                        break
                    }
            }
            break
        case "requestSaveNewVideo":
            ///
            /// Request for Saving New Video
            ///
            Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
                .responseString { response in
                    switch response.result {
                    case .success:
                        print("SUCCESS -> \(JSON(data: response.data!))")
                        let jsonData = JSON(data: response.data!)
                        if let id = jsonData["video_db_id"].int {
                            videoData?._videoId = jsonData["video_db_id"].intValue
                        }
                        self.dataArr.append(videoData!)
                        self.tableView.reloadData()
                        break
                    case .failure(let error):
                        print("EREROR: -> \(error)")
                        break
                    }
            }
            break
        case "requestDeleteVideo":
            ///
            /// Request for Deleting Video
            ///
            Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
                .responseString { response in
                    switch response.result {
                    case .success:
                        print("SUCCESS -> \(JSON(data: response.data!))")
                        self.removeVideo(video: videoData!, index: videoIndex!)
                        break
                    case .failure(let error):
                        print("EREROR: -> \(error)")
                        break
                    }
            }
            break
        default:
            print ("[!] Request Mode Error")
        }
        
    }
    
    func requestTableViewData() {
        let parameters = [
            "type" : "user_videos",
            "username": self.containerName! //Username
        ] as [String: Any]
        let appendix = "user_videos"
        let url = "http://13.66.48.219:8000/pinpin/\(appendix)/"
        print ("#### SENDING REQUEST [Request User Videos] \n\(parameters)")
        requestToServer(videoIndex: nil,
                        videoData: nil,
                        url: url,
                        parameters: parameters,
                        mode: "requestTableViewData")
    }
    
    func requestSaveNewVideo(video: Video) {
        let appendix = "new_video"
        let url = "http://13.66.48.219:8000/pinpin/\(appendix)/"
        let parameters = [
            "type": "save_new_video",
            "username": self.containerName!,
            "link": video._link!,
            "title": video._title!,
            "date": video._time!,
            "description": video._description!
        ] as [String: Any]
        print ("#### SENDING REQUEST [Adding New Video] \n\(parameters)")
        requestToServer(videoIndex: nil,
                        videoData: video,
                        url: url,
                        parameters: parameters,
                        mode: "requestSaveNewVideo")
    }
    
    func requestDeleteVideo(video: Video, index: Int) {
        let appendix = "delete_video"
        let url = "http://13.66.48.219:8000/pinpin/\(appendix)/"
        let parameters = [
            "type": "delete_video",
            "username": self.containerName!,
            "video_db_id": video._videoId!
            ] as [String: Any]
        print ("#### SENDING REQUEST [Deleting Video] \n\(parameters)")
        requestToServer(videoIndex: index,
                        videoData: video,
                        url: url,
                        parameters: parameters,
                        mode: "requestDeleteVideo")
    }
    
}

extension VideosViewController: NVActivityIndicatorViewable {
}
