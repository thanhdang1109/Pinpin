/*
 
  ResumeTableCellSectionTitle.swift
  Awesome Resume

  Created by BOYA CHEN on 11/9/17.
  Copyright © 2017 Awesome Team. All rights reserved.
 
*/

import UIKit

class ResumeTableCellEducation: UITableViewCell {
    
    @IBOutlet weak var TableCellSectionTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var cellIndex: Int?
    var delegate: ViewCellDelegate!
    var eduInfo: [[String: String]]?
    var cellHeight: CGFloat?
    
    func getCellHeight() -> CGFloat{
        return cellHeight!
    }

    func configCell(eduInfo: [[String: String]]){
        
        for sbv in stackView.subviews{
            print("edu cleans \(sbv)")
            let height = sbv.frame.size.height
            sbv.removeFromSuperview()
            stackView.frame.size.height -= height
        }
        
        print(":: Config ---------- EDU")
        
        self.TableCellSectionTitle.text = "Education".uppercased()
        // Inject the data
        self.eduInfo = eduInfo
        // Setting stackView
        
        // Recursively adding education items
        for item in eduInfo{
            newEdu(data: item)
        }
        
        cellHeight = stackView.bounds.size.height
        
    }
    
    func newEdu(data: [String: String]) {
        
        let newView = UIStackView()
        newView.axis = UILayoutConstraintAxis.vertical
        newView.distribution = UIStackViewDistribution.fillProportionally
        
        // -- Adding Tapping Action
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handleTap))
        tap.delegate = self
        newView.addGestureRecognizer(tap)
        
        // -- Acquiring the data
        let eduName: String = data["organization"]!
        let eduTitle: String = data["title"]!
        let eduTime: String = data["time"]!
        let eduLocation: String = data["location"]!
        let eduInfo: String = data["description"]!
        
        // -- Default Font
        let fontBold = UIFont.init(name: "Palatino-Bold", size: 15)
        let fontRegular = UIFont.init(name: "Palatino", size: 14)
        
        // -- Education Name (Organization)
        let educationName = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        educationName.lineBreakMode = .byWordWrapping
        educationName.numberOfLines = 0
        educationName.font = fontBold
        educationName.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        educationName.text = eduName
        newView.addArrangedSubview(educationName)
        
        // -- Education Title
        let educationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        educationTitle.lineBreakMode = .byWordWrapping
        educationTitle.numberOfLines = 0
        educationTitle.font = fontRegular
        educationTitle.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        educationTitle.text = eduTitle
        educationTitle.sizeToFit()
        newView.addArrangedSubview(educationTitle)
        
        // -- Education Time
        let educationTime = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        educationTime.lineBreakMode = .byWordWrapping
        educationTime.numberOfLines = 0
        educationTime.font = fontRegular
        educationTime.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        educationTime.text = eduTime
        educationTime.sizeToFit()
        newView.addArrangedSubview(educationTime)
        
        // -- Education Location
        let educationLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        educationLocation.lineBreakMode = .byWordWrapping
        educationLocation.numberOfLines = 0
        educationLocation.font = fontRegular
        educationLocation.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        educationLocation.text = eduLocation
        educationLocation.sizeToFit()
        newView.addArrangedSubview(educationLocation)

        // -- Education Inforamtion
        let educationInfo = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        educationInfo.lineBreakMode = .byWordWrapping
        educationInfo.numberOfLines = 0
        educationInfo.font = fontRegular
        educationInfo.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        educationInfo.text = eduInfo
        educationInfo.sizeToFit()
        newView.addArrangedSubview(educationInfo)
        
        let addedHeight =
            educationName.frame.size.height + educationInfo.frame.size.height +
            educationTitle.frame.size.height + educationTime.frame.size.height +
            educationLocation.frame.size.height
        
//        newView.frame.size.height = addedHeight
        
        stackView.insertArrangedSubview(newView, at: stackView.arrangedSubviews.count)
        
        stackView.frame.size.height += addedHeight
        newView.frame.size.height = addedHeight
        newView.distribution = .fillProportionally
        
//        newView.addConstraint(NSLayoutConstraint)
        
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
