//
//  EditMode1VC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 16/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import AVFoundation

protocol SaveDataDelegate {
    func saveBtnPressed(data: [String:String], dataType: String, isSave: Bool, editIndex: Int)
}

class EditMode1VC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    // -- Data
    var type: String?
    var isSave = true
    var editData: [String: String]?
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
    
    @IBAction func videoBtnAction(_ sender: UIBarButtonItem) {
        print ("Video!!!")
    }
    @IBAction func deleteBtnAction(_ sender: UIBarButtonItem) {
        print ("Delete!!!")
        let deleteBtnAlert = UIAlertController(title: "Are you sure deleting this item?", message: "", preferredStyle: .alert)
        deleteBtnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(deleteBtnAlert, animated: true, completion: nil)
        deleteBtnAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            if (self.editIndex >= 0) {
                self.delegate?.saveBtnPressed(data: [:], dataType: "deleting_education", isSave: true, editIndex: self.editIndex) };
            self.navigationController?.popViewController(animated: true)
        }))
    }
    
    func configureData(type: String, data: [String: String], editIndex: Int) {
        self.editData = data
        self.type = type
        self.editIndex = editIndex
        print ("Type has been set to \(type)")
    }
    
    override func viewDidLoad() {
        
        /// Common Action After View's been loaded
        super.viewDidLoad()
        // Delegate UITextView
        DescText.delegate = self
        // Rezie the textview
        DescriptionTextView.textContainerInset = UIEdgeInsets.zero
        DescriptionTextView.textContainer.lineFragmentPadding = 0
        // Some settings for navigation bar
        // -- Adding title
        settingTitle(type: self.type!)
        
        // -- Adding save button
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        // Back Button
        // -- Adding back button
        let newBackBtn = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backBtnAlertAction))
        self.navigationItem.setLeftBarButton(newBackBtn, animated: true)
        // -- Swipe back gesture
        let swipeBack = UISwipeGestureRecognizer()
        swipeBack.direction = .right
        swipeBack.addTarget(self, action: #selector(goBack))
        self.ContentView.addGestureRecognizer(swipeBack)
    }
    
    // Rewrite the UITextView shouldChangeTextIn in order to add bullet points
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // If the replacement text is "\n" and the
        // text view is the one you want bullet points
        // for
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
    
    // -- Filling text into text input fields
    func fillText(fillData: [String: String]) {
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
    
    // :: Save button actions
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        ///
        /// Save Button in Edit Page
        ///
        // When self.data is nil, it shold be "Adding Mode"
        switch self.type! {
        case "adding_education":
            print ("This is an empty document")
            let data: [String: String] = [
                "organization": OrganText.text!,
                "title": TitleText.text!,
                "time": TimeText.text!,
                "location": LocationText.text!,
                "description": DescText.text!
            ]
            if OrganText.text! == ""{
                isSave = false
            }
            delegate?.saveBtnPressed(data: data, dataType: type!, isSave: isSave, editIndex: -1)
            self.navigationController?.popViewController(animated: true)
        case "editting_education":
            print("::Save Education")
            let data: [String: String] = [
                "organization": OrganText.text!,
                "title": TitleText.text!,
                "time": TimeText.text!,
                "location": LocationText.text!,
                "description": DescText.text!
            ]
            if OrganText.text! == ""{
                isSave = false
            }
            delegate?.saveBtnPressed(data: data, dataType: type!, isSave: isSave, editIndex: self.editIndex)
            self.navigationController?.popViewController(animated: true)
        default:
            print(self.editData)
        }
    }
    
    
    
    // :: Go back button alert
    @objc func backBtnAlertAction(sender: UIBarButtonItem) {
        let backBtnAlert = UIAlertController(title: "Are you sure to go back?", message: "", preferredStyle: .alert)
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
    
}
