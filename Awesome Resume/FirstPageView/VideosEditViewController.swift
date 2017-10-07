//
//  VideosEditViewController.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 30/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import NVActivityIndicatorView


protocol SaveDataDelegate {
    func saveBtnPressed(data: Video)
}

class VideosEditViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var TitleContent: UITextField!
    @IBOutlet weak var DateContent: UITextField!
    @IBOutlet weak var DescContent: UITextView!
    
    var saveDataDelegate: SaveDataDelegate? = nil
    
    var tempVideo: NSData!
    var tempVideoName: String!
    var tempSavePath: String!
    
    var editMode: String!
    // Edit Mode: 1) Add 2) Edit
    
    
    
    func configEditPage(data: Video, mode: String) {
        
        
    }
    
    @IBAction func RecordBtn(_ sender: Any) {
        print ("Record")
        if startCameraFromViewController(viewController: self, withDelegate: self) == false{
            print ("Initialize Camera Failed.")
        }
        
    }
    
    @IBAction func SaveBtn(_ sender: Any) {
        print ("Save")
        if self.tempSavePath != nil {
            confirmSave()
        }else{
            let alert = UIAlertController.init(title: "Video Requried",
                                               message: "Your must record the video to save",
                                               preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Must Record Video")
        }
    }
    
    func confirmSave(){
        self.startActivityAnimating(message: "Uploading Video")
        
        self.tempVideo?.write(toFile: self.tempSavePath, atomically: false)
        
//        self.tempVideo.writeToURL(named: self.tempVideoName) { (result, url) in
//            self.tempSavePath = url?.relativeString
//            print(self.tempSavePath)
//            let videoData = Video(title: self.TitleContent.text!,
//                                  description: self.DescContent.text!,
//                                  time: self.DateContent.text!,
//                                  link: self.tempSavePath,
//                                  filename: self.tempVideoName)
//            self.saveDataDelegate?.saveBtnPressed(data: videoData)
//            self.navigationController?.popViewController(animated: true)
//        }
        
        let videoData = Video(title: self.TitleContent.text!,
                                          description: self.DescContent.text!,
                                          time: self.DateContent.text!,
                                          link: self.tempSavePath,
                                          filename: self.tempVideoName)
        self.saveDataDelegate?.saveBtnPressed(data: videoData)
        self.navigationController?.popViewController(animated: true)
        
        
        
        
//        let alert = UIAlertController(title: "Save Data?",
//                                      message: self.tempSavePath,
//                                      preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Save",
//                                      style: .default,
//                                      handler: {
//            (action) in self.tempVideo?.write(toFile: self.tempSavePath, atomically: false)
//                        self.startActivityAnimating(message: "Uploading Video")
////                        self.navigationController?.popViewController(animated: true)
//                        self.saveDataDelegate?.saveBtnPressed(data: videoData)
        
//        }))
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
//            (action) in self.navigationController?.popViewController(animated: true)
//        }))
        
//        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add/Edit"
        let rightBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishEdit))
        self.navigationItem.rightBarButtonItem = rightBtn
        // Do any additional setup after loading the view.
    }

    @objc func finishEdit(_ sender: Any){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////////////
    ///                         ///
    ///---- Video Recording ----///
    ///                         ///
    ///////////////////////////////
    
    func startCameraFromViewController(viewController: UIViewController,
                                       withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        ///
        /// startCameraFromViewController
        /// Next Step -> func imagePickerController
        ///
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = true
        cameraController.cameraDevice = .front
        // --> "cameraController": A Boolean value indicating whether the user is allowed to edit a selected still image or movie.
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
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

    
    
    // ANIMATION
    func startActivityAnimating(message: String) {
        self.startAnimating(CGRect(x:0,y:0,width:60,height:60).size, message: message, messageFont: nil, type: .ballScaleMultiple, color: #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1))
    }
    
    func stopActivityAnimating() {
        self.stopAnimating()
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

extension VideosEditViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ///
        /// Callback function after the video's been recorded
        ///
        // let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        // Handle a movie capture
        // 1 --- store the video URL returned by UIImagePickerController *** //
        let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
        // 2 --- load video data from URL *** //
        let videoData = NSData.init(contentsOf: videoURL as URL)
        // 3 --- Get documents directory path *** //
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                        FileManager.SearchPathDomainMask.userDomainMask,
                                                        true)[0]
        // 4 --- Append video file name *** //
        let uuid = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
        let fileName = "video-"+uuid+".mp4"
        self.tempVideoName = fileName
        let dataPath = paths + "/video-"+uuid+".mp4"
//        let dataPath = paths + "/video.mp4"
        print ("Video Path: " + dataPath)
//        self.saveDataDelegate?.saveBtnPressed(data: dataPath)
        self.tempVideo = videoData
        self.tempSavePath = dataPath
//        self.editData!["video"] = dataPath
//        print (self.editData)
        // *** Write video file data to path *** //
//         videoData?.write(toFile: dataPath, atomically: false)
//        delegate?.saveBtnPressed(data: self.editData!, dataType: self.type!, isSave: isSave, editIndex: self.editIndex)
        // clearTmpDirectory()
    }
    

    
}


extension VideosEditViewController: NVActivityIndicatorViewable {
    
}


extension NSData {
    
    func writeToURL(named:String, completion: @escaping (_ result: Bool, _ url:NSURL?) -> Void)  {
        
        let filePath = NSTemporaryDirectory() + named
        //var success:Bool = false
        let tmpURL = NSURL( fileURLWithPath:  filePath )
        weak var weakSelf = self
        
        DispatchQueue.main.async(group: DispatchGroup.init(), execute: {
            //write to URL atomically
            if weakSelf!.write(to: tmpURL as URL, atomically: true) {
                
                if FileManager.default.fileExists( atPath: filePath ) {
                    completion(true, tmpURL)
                } else {
                    completion (false, tmpURL)
                }
            }
        })
        
    }
}
