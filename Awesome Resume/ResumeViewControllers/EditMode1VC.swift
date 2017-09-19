//
//  EditMode1VC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 16/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

protocol SaveDataDelegate {
    func saveBtnPressed(data: [String:String], dataType: String, isSave: Bool)
}

class EditMode1VC: UIViewController {

    @IBOutlet weak var DescriptionTextView: UITextView!
    
    // -- Data
    var type: String?
    var isSave = true
    var data: [String: String]?
    var delegate: SaveDataDelegate? = nil
    
    // Textview Content
    
    @IBOutlet weak var OrganText: UITextField!
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var TimeText: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var DescText: UITextView!
    
    func configureData(type: String) {
        self.type = type
        print ("Type has been set to \(type)")
    }
    
    override func viewDidLoad() {
        /// Common Action After View's been loaded
        super.viewDidLoad()
        // Rezie the textview
        DescriptionTextView.textContainerInset = UIEdgeInsets.zero
        DescriptionTextView.textContainer.lineFragmentPadding = 0
        // Some settings for navigation bar
        // --  Adding save button
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        // Back Button
        // -- Adding back button
        let newBackBtn = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backBtnAlertAction))
        self.navigationItem.setLeftBarButton(newBackBtn, animated: true)
//        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
//            NSAttributedStringKey.font : UIFont(name: "Avenir-bold", size: 23) ?? UIFont.systemFont(ofSize: 20)
//            ], for: UIControlState.normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        ///
        /// Save Button in Edit Page
        ///
        // When self.data is nil, it shold be "Adding Mode"
        if self.data == nil{
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
            delegate?.saveBtnPressed(data: data, dataType: type!, isSave: isSave)
            self.navigationController?.popViewController(animated: true)
        }else{
            print(self.data)
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
    
}
