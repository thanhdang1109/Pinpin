//
//  ResumeTableCellExp.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 15/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumeTableCellExp: UITableViewCell {

    @IBOutlet weak var TableCellSectionTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var cellIndex: Int?
    var delegate: ViewCellDelegate!
    var eduExp: [[String: String]]?
    var cellHeight: CGFloat?
    
    func getCellHeight() -> CGFloat{
        return cellHeight!
    }
    
    func configCell(eduExp: [[String: String]]){
    
        for sbv in stackView.subviews{
            print("exp cleans \(sbv)")
            let height = sbv.frame.size.height
            sbv.removeFromSuperview()
            stackView.frame.size.height -= height
        }
        
        print(":: Config ---------- EXP")
        
        self.TableCellSectionTitle.text = "Experience".uppercased()
        // Inject the data
        self.eduExp = eduExp
        // Setting stackView
        
        // Recursively adding education items
        for item in eduExp {
            newExp(data: item)
        }
        
        cellHeight = stackView.bounds.size.height
        
    }
    
    func newExp(data: [String: String]) {
        
        let newView = UIStackView()
        newView.axis = UILayoutConstraintAxis.vertical
        newView.distribution = UIStackViewDistribution.fillProportionally
        
        // -- Adding Tapping Action
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handleTap))
        tap.delegate = self
        newView.addGestureRecognizer(tap)
        
        // -- Acquiring the data
        let expOrg: String = data["organization"]!
        let expTitle: String = data["title"]!
        let expTime: String = data["time"]!
        let expLocation: String = data["location"]!
        let expInfo: String = data["description"]!
        
        // -- Default Font
        let fontBold = UIFont.init(name: "Palatino-Bold", size: 15)
        let fontRegular = UIFont.init(name: "Palatino", size: 14)
        
        // -- Education Name (Organization)
        let experienceOrgan = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        experienceOrgan.lineBreakMode = .byWordWrapping
        experienceOrgan.numberOfLines = 0
        experienceOrgan.font = fontBold
        experienceOrgan.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        experienceOrgan.text = expOrg
        newView.addArrangedSubview(experienceOrgan)
        
        // -- Education Title
        let experienceTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        experienceTitle.lineBreakMode = .byWordWrapping
        experienceTitle.numberOfLines = 0
        experienceTitle.font = fontRegular
        experienceTitle.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        experienceTitle.text = expTitle
        experienceTitle.sizeToFit()
        newView.addArrangedSubview(experienceTitle)
        
        // -- Education Time
        let experienceTime = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        experienceTime.lineBreakMode = .byWordWrapping
        experienceTime.numberOfLines = 0
        experienceTime.font = fontRegular
        experienceTime.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        experienceTime.text = expTime
        experienceTime.sizeToFit()
        newView.addArrangedSubview(experienceTime)
        
        // -- Education Location
        let experienceLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        experienceLocation.lineBreakMode = .byWordWrapping
        experienceLocation.numberOfLines = 0
        experienceLocation.font = fontRegular
        experienceLocation.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        experienceLocation.text = expLocation
        experienceLocation.sizeToFit()
        newView.addArrangedSubview(experienceLocation)
        
        // -- Education Inforamtion
        let experienceInfo = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        experienceInfo.lineBreakMode = .byWordWrapping
        experienceInfo.numberOfLines = 0
        experienceInfo.font = fontRegular
        experienceInfo.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        experienceInfo.text = expInfo
        experienceInfo.sizeToFit()
        newView.addArrangedSubview(experienceInfo)
        
        
        let addedHeight =
            experienceOrgan.frame.size.height + experienceInfo.frame.size.height +
                experienceTitle.frame.size.height + experienceTime.frame.size.height +
                experienceLocation.frame.size.height
        
        stackView.frame.size.height += addedHeight
        newView.frame.size.height = addedHeight
        
        
        stackView.insertArrangedSubview(newView, at: stackView.arrangedSubviews.count)
        
        print("::stackView Height: \(stackView.frame.height)")
        print("::cell Height: \(self.frame.size.height)")
        
        //        delegate.updateCellHeights(height: self.frame.size.height + addedHeight,
        //                                   index: self.cellIndex!)
        
        print("#stackView Height: \(stackView.frame.height)")
        print("#cell Height: \(self.frame.size.height)")
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        let tapIndex:Int = stackView.subviews.index(of:(sender?.view!)!)!
        //        print(eduInfo![tapIndex])
        print("Tap Index: \(tapIndex)")
        print(sender?.view?.frame)
        //        let editView = EditMode1VC()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
