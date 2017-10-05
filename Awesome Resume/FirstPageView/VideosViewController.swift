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
        Video(title: "Claude Chen", description: "2 Cobden st. North Melbourne, 3051 VIC", time: "", link: "https://cs1ea921f0a44b4x43fbxa0e.blob.core.windows.net/videocontainerone/video.mp4", filename: ""),
                Video(title: "University of Melbourne", description: "Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology, Master of Information Technology", time: "2016-2018", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
                Video(title: "UESTC", description: "Bachalor of Computer Science and Technology", time: "", link: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", filename: ""),
    ]
    var player : VGPlayer!
    var playerView : VGEmbedPlayerView!
    var currentPlayIndexPath : IndexPath?
    var smallScreenView : UIView!
    var panGesture = UIPanGestureRecognizer()
    var playerViewSize : CGSize?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        ///
        /// View Did Load !!!!!!!!!!!!!
        ///
        super.viewDidLoad()
        
        self.connectionString = "DefaultEndpointsProtocol=https;AccountName=cs1ea921f0a44b4x43fbxa0e;AccountKey=B41efiZWKDOt8Gxi0ku/MrHJJoiM7Aal0JA71dJJG0Nx6GNtkQ8fHZZdi8YnD/rwlaXtbejv18ZSm/DceRSGlw=="
        
        self.containerName = self.defaults.string(forKey: "userName")
        print("User Name:"+self.containerName)
        
        if self.tableView.isEditing != false{
            self.tableView.isEditing = false
        }
    
    
        self.navigationItem.title = "My Resume"
        
        configureSmallScreenView()
        addTableViewObservers()
        
        self.tableView.refreshControl = self.refreshCtrl // Adding refresh control
        
        self.tableView.reloadData()
    }
    

    
    func uploadVideo(fileName: String, filePath: String) -> String {

        ///
        /// Azure Blob Files Handles
        /// Uploading Videos.
        ///

        // Create a semaphore to prevent the method from exiting before all of the async operations finish.
        // In most real applications, you wouldn't do this, it makes this whole series of operations synchronous.
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

        print ("Start Uploading the \(filePath)")
        blockBlob?.upload(from: InputStream.init(fileAtPath: filePath)!, completionHandler: { (_ error: Error?) in
            if error != nil {
                print("Error in uploading blob.\n --> \(error!)")
                return
            }
            print(":: Upload Successfully!")
            let successAlert = UIAlertController.init(title: "Upload Successfully!", message: "", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
            self.present(successAlert, animated: true, completion: nil)
            
            print ("Upload Successfully!")
            semaphore.signal()
        })
        
        return ("https://cs1ea921f0a44b4x43fbxa0e.blob.core.windows.net/\(self.containerName!)/\(fileName)")
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

    @IBAction func NavigationBtnUploading(_ sender: UIBarButtonItem) {
        print(self.dataArr)
//        createAndDeleteBlob()
    }
    
    @IBAction func NavigationBtnAdding(_ sender: UIBarButtonItem) {
        ///
        /// Action for the Adding Button on the Navigation Bar
        ///
        self.tableView.reloadData()
        print ("Adding New Item!")
    }
    
    @IBAction func NavigationBtnEdit(_ sender: UIBarButtonItem) {
        ///
        /// Action for the Edit Button on the Navigation Bar
        ///
        // -- Toggle the Edit the mode
        if (self.isEditing == true) {
            self.isEditing = false
        }else{
            self.isEditing = true
        }
        print ("Edit The Table")
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
        refreshControl.endRefreshing()
    }

//    func requestJSONFromServer(url: String, parameters: [String: Any]) -> Any {
//        var returnData: Any?
//        Alamofire.request(url).responseJSON { (response) in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")
//            let json = JSON(data: response.data)
//            response serialization result
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//                returnData = data
//            } else {
//                returnData = ""
//            }
//        }
//        return returnData ?? ""
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        // Overwrite the viewWillDisappear
        //
        super.viewWillDisappear(animated)
        if let smallScreenView = smallScreenView {
            smallScreenView.removeFromSuperview()
        }
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
    
    deinit {
        if let playerCheck = player {
            player.cleanPlayer()
        }
        removeTableViewObservers()
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
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        /// Swipe to delete
//        if editingStyle == .delete {
//
//            // remove the item from the data model
//            dataArr.remove(at: indexPath.row)
//
//            // delete the table view row
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Not used in our example, but if you were adding a new row, this is where you would do it.
//        }
//    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = self.dataArr[sourceIndexPath.row]
        self.dataArr.remove(at: sourceIndexPath.row)
        self.dataArr.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    
    ///////////////////////////////////////////////
    ///
    /// Handle Video Players
    ///
    ///////////////////////////////////////////////
    
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
    
    func saveBtnPressed(data: Video){
        ///
        /// Save Data Delegate Function
        ///
        print (data._fileName!)
        print (data._link!)
        let onlineLink = uploadVideo(fileName: data._fileName!, filePath: data._link!) // UPLOADING VIDEO
        
        data._link = onlineLink // Update the link
        self.dataArr.append(data)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSegue"{
            let vc: VideosEditViewController = segue.destination as! VideosEditViewController
            vc.saveDataDelegate = self
        }
    }
}

extension VideosViewController {
    
    /// Extension to the VideoViewController
    ///
    /// - Parameters:
    ///   - keyPath: <#keyPath description#>
    ///   - object: <#object description#>
    ///   - change: <#change description#>
    ///   - context: <#context description#>
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
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
//                        addSmallScreenView()
                    }
                } else {
                    if isViewLoaded && (view.window != nil) {
                        if smallScreenView.superview != UIApplication.shared.keyWindow {
//                            addSmallScreenView()
                        }
                    }
                }
            }
        }
        //        }
    }
    
    func testingOurServerAPI(url: String, parameters: [String: String]) {
        print("---------------- TESTING ---------------")
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
//
                Alamofire.request(url, method: .post, parameters: parameters, headers: nil).responseString {
                    response in
                    print("JSON TESTING: \(url)")
                    switch response.result {
                    case .success:
                        print("SUCCESSFUL: -> \(response)")

                        break
                    case .failure(let error):

                        print("EREROR: -> \(error)")
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
