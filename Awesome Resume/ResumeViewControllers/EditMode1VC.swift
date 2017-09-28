//
//  EditMode1VC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 16/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

protocol SaveDataDelegate {
    func saveBtnPressed(data: [String:String], dataType: String, isSave: Bool, editIndex: Int)
}

class EditMode1VC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    // -- Data
    var type: String?
    var isSave = true
    var editData: [String: String]?
    var editSection: Int!
    var editRow: Int!
    var editIndex: Int!
    var delegate: SaveDataDelegate? = nil
    
    // Textview Content
    
    @IBOutlet weak var OrganText: UITextField!
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var TimeText: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var DescText: UITextView!
    @IBOutlet weak var ContentView: UIView!
    // Toolbar Btn

    @IBOutlet weak var toolbarView: UIView!
    
    @IBAction func backBtn(_ sender: UIButton) {
        let backBtnAlert = UIAlertController(title: "Are you sure you want to go back?", message: "", preferredStyle: .alert)
        backBtnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(backBtnAlert, animated: true, completion: nil)
        backBtnAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in self.navigationController?.popViewController(animated: true)
        }))
    }
    
    @IBAction func videoBtn(_ sender: UIButton) {
        print ("Video!!!")
        if startCameraFromViewController(viewController: self, withDelegate: self) == false{
            print ("Initialize Camera Failed.")
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        print ("Delete!!!")
        let deleteBtnAlert = UIAlertController(title: "Are you sure you want delete this item?", message: "", preferredStyle: .alert)
        deleteBtnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(deleteBtnAlert, animated: true, completion: nil)
        deleteBtnAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            if (self.editIndex >= 0) {
                self.delegate?.saveBtnPressed(data: [:], dataType: "deleting_education", isSave: true, editIndex: self.editIndex) };
            self.navigationController?.popViewController(animated: true)
        }))
    }
    
    /////////////////////////////////////////////////////////////
    //
    // -----> viewDidLoad
    //
    /////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        ///
        /// Common Actions After View's been loaded
        ///
        super.viewDidLoad()
        // Delegate UITextView
        DescText.delegate = self
        // Rezie the textview
        DescriptionTextView.textContainerInset = UIEdgeInsets.zero
        DescriptionTextView.textContainer.lineFragmentPadding = 0
        // -- Adding title
        settingTitle(type: self.type!)
        // -- Adding save button
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        // Back Button
        // -- Adding back button
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil), animated: true)
        // -- Attatch keyboard to toolbar
        // self.DescText.inputAccessoryView = self.toolbarView
        var pageVC = self.storyboard?.instantiateViewController(withIdentifier: "ResumePagesVC") as? UIPageViewController
        
        
    }
    
    
    func configureData(type: String, data: [String: String], editIndex: Int) {
        self.editData = data
        self.type = type
        self.editIndex = editIndex
        print ("Type has been set to \(type)")
    }
    
    
    // Rewrite the UITextView shouldChangeTextIn in order to add bullet points
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ///
        /// Rewrite the textview writing rules (Automatic adding bullet points)
        ///
        
        
        // Limit the characters
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        if (changedText.count > 500) {return false}
        
        if (text == "\n") {
            // If the replacement text is being added to the end of the
            // text view, i.e. the new index is the length of the old
            // text view's text...
            if range.location == textView.text.characters.count {
                // Simply add the newline and bullet point to the end
                let updatedText: String = textView.text!.appendingFormat("\n- ")
                textView.text = updatedText
            }
            else {
                // Get the replacement range of the UITextView
                let beginning: UITextPosition = textView.beginningOfDocument
                let start: UITextPosition = textView.position(from: beginning, offset: range.location)!
                let end: UITextPosition = textView.position(from: start, offset: range.length)!
                let textRange: UITextRange = textView.textRange(from: start, to: end)!
                // Insert that newline character *and* a bullet point
                // at the point at which the user inputted just the
                // newline character
                textView.replace(textRange, withText: "\n- ")
                // Update the cursor position accordingly
                let cursor: NSRange = NSMakeRange(range.location + "\n- ".count, 0)
                textView.selectedRange = cursor
            }
            return false
        }
        // Else return yes
        return true
    }
    
    
    // -- Setting Navigation bar title
    func settingTitle(type: String) {
        ///
        /// Customise title for navigation bar
        ///
        switch type {
        case "adding_education":
            self.navigationItem.title = "Add Education"
        case "adding_experience":
            self.navigationItem.title = "Add Experience"
        case "editting_education":
            self.navigationItem.title = "Edit Education"
            fillText(fillData:self.editData!)
        default:
            print (":: title setting error!")
        }
    }
    
    
    func fillText(fillData: [String: String]) {
        ///
        /// Filling text into text input fields
        ///
        self.OrganText.text = fillData["organization"]
        self.TitleText.text = fillData["title"]
        self.TimeText.text = fillData["time"]
        self.LocationText.text = fillData["location"]
        self.DescText.text = fillData["description"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modifyEditData(){
        /*
        Modify the 'editData' in terms of all text fields
        */
        self.editData!["organization"] = OrganText.text!
        self.editData!["title"] = TitleText.text!
        self.editData!["time"] = TimeText.text!
        self.editData!["location"] = LocationText.text!
        self.editData!["description"] = DescText.text!
    }
    
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        ///
        /// Action for Save Button in the top-right corner
        ///
        // When self.data is nil, it shold be "Adding Mode"
        switch self.type! {
        case "adding_education":
            print ("This is an empty document")
            modifyEditData()
            if  self.editData!["organization"] == ""{
                isSave = false
            }
            delegate?.saveBtnPressed(data: self.editData!, dataType: self.type!, isSave: isSave, editIndex: -1)
            self.navigationController?.popViewController(animated: true)
        case "editting_education":
            print("::Save Education")
            modifyEditData()
            if OrganText.text! == ""{
                isSave = false
            }
            delegate?.saveBtnPressed(data: self.editData!, dataType: self.type!, isSave: isSave, editIndex: self.editIndex)
            self.navigationController?.popViewController(animated: true)
        default:
            print(self.editData)
        }
    }
    
    // :: Go back button alert
    @objc func backBtnAlertAction(sender: UIBarButtonItem) {
        let backBtnAlert = UIAlertController(title: "Are you sure you want to go back?", message: "", preferredStyle: .alert)
        backBtnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(backBtnAlert, animated: true, completion: nil)
        backBtnAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in self.navigationController?.popViewController(animated: true)
        }))
    }
    
    // :: Just Go back
    @objc func goBack(sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //////////////////////////////////////////////////////////////
    /////
    /////       Video
    /////
    //////////////////////////////////////////////////////////////
 
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

    func saveVideo(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        ///
        /// Function to Save Video
        ///
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension EditMode1VC: UIImagePickerControllerDelegate {
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
        let uuid = NSUUID().uuidString
        let dataPath = paths + "/video-"+uuid+".mp4"
        self.editData!["video"] = dataPath
        print (self.editData)
        // *** Write video file data to path *** //
        // videoData?.write(toFile: dataPath, atomically: false)
        delegate?.saveBtnPressed(data: self.editData!, dataType: self.type!, isSave: isSave, editIndex: self.editIndex)
        // clearTmpDirectory()
    }
    
    func clearTmpDirectory() {
        let tmpDirectory = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
        for file: String in tmpDirectory! {
            try? FileManager.default.removeItem(atPath: "\(NSTemporaryDirectory())\(file)")
        }
    }

}

extension EditMode1VC: UINavigationControllerDelegate {
}

