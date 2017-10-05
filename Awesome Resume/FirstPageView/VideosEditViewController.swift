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
            let alert = UIAlertController.init(title: "Video Requried", message: "Your must record the video to save", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Must Record Video")
        }
    }
    
    func confirmSave(){
        let videoData = Video.init(title: self.TitleContent.text!,
                                   description: self.DescContent.text!,
                                   time: self.DateContent.text!,
                                   link: self.tempSavePath,
                                   filename: self.tempVideoName)
        
        let alert = UIAlertController(title: "Save Data?", message: self.tempSavePath, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            (action) in self.tempVideo?.write(toFile: self.tempSavePath, atomically: false);
                        self.saveDataDelegate?.saveBtnPressed(data: videoData);
                        self.navigationController?.popViewController(animated: true);
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add/Edit"

        // Do any additional setup after loading the view.
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
        // videoData?.write(toFile: dataPath, atomically: false)
//        delegate?.saveBtnPressed(data: self.editData!, dataType: self.type!, isSave: isSave, editIndex: self.editIndex)
        // clearTmpDirectory()
    }
    

    
}
