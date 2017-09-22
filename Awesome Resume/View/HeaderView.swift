//
//  HeaderView.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 19/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var cellType: String?
    
    func configHeader(headerTitleString: String, cellType: String) {
        
        self.cellType = cellType
        
        let stackView = UIStackView()
        
        stackView.distribution = .fillProportionally
        
        let uiView = UIView()
        uiView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        uiView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(uiView)
        
        let uiLabel = UILabel()
        uiLabel.frame.origin.x = 20
        uiLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        uiLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uiLabel.text = headerTitleString
        uiLabel.font = UIFont(name: "Avenir Next Bold", size: 16)
        stackView.addArrangedSubview(uiLabel)
        
        let uiButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        uiButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        uiButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        uiButton.setTitle("+", for: .normal)
        uiButton.setTitleColor(UIColor(red:0.57, green:0.07, blue:0.04, alpha:1.0), for: .normal)
        uiButton.addTarget(self, action: #selector(addingButton), for: UIControlEvents.touchUpInside)
        stackView.addArrangedSubview(uiButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        self.addConstraint(NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        // Other Cell Configuration
        self.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
    }
    
    @objc func addingButton(sender: UIButton){
        print("Touch!")
        let touchType:String = self.cellType!
        let vc:UIViewController = self.getParentViewController()!
        let editVC:EditMode1VC = (vc.storyboard?.instantiateViewController(withIdentifier: "EditMode1VC"))! as! EditMode1VC
        editVC.delegate = vc as! SaveDataDelegate
        switch touchType {
        case "EDUCATION":
            print("prepare to go to edu!")
            editVC.configureData(type: "adding_education", data: [:], editIndex: -1)
            vc.navigationController?.pushViewController(editVC, animated: true)
        case "EXPERIENCE":
            print("prepare to go to exp!")
            editVC.configureData(type: "adding_experience", data: [:], editIndex: -1)
            vc.navigationController?.pushViewController(editVC, animated: true)
        default:
            print("# wrong button pressed")
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
