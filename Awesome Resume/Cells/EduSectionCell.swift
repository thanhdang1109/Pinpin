//
//  EduSectionCell.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 20/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class EduSectionCell: UITableViewCell {

    @IBOutlet weak var eduOrgan: UILabel!
    @IBOutlet weak var eduTitle: UILabel!
    @IBOutlet weak var eduTime: UILabel!
    @IBOutlet weak var eduLocation: UILabel!
    @IBOutlet weak var eduDesc: UILabel!
    @IBOutlet weak var video_marker: UIImageView!
    
    // -- Local Variables
    var cellData: [String: String]!
    var cellTag: Int!
    var cellHeight: CGFloat!

    func setCellTag(tag: Int){
        self.cellTag = tag
    }
    
    func configCell(data: [String: String], tag: Int) {
        self.cellData = data
        self.cellTag = tag
        
        self.eduOrgan?.text = data["organization"]
        self.eduTitle?.text = data["title"]
        self.eduTime?.text = data["time"]
        self.eduLocation?.text = data["location"]
        self.eduDesc?.text = data["description"]
        eduDesc.lineBreakMode = .byWordWrapping
        eduDesc.numberOfLines = 0
        
        // Toggle the video marker
        if data["video"] == nil {
            self.video_marker.isHidden = true
        }else{
            self.video_marker.isHidden = false
        }
        
        // Adding gesture
        let cellGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapHandler))
        self.addGestureRecognizer(cellGesture)
        
        let descHeight = computeLabelHeight(data["description"]!, eduDesc.font, self.frame.width)
        let cHeight = descHeight + 82
        self.cellHeight = cHeight
        
    }
    
    //
    // The part below is used for computing cell height dynamically
    //
    
    func getCellHeight() -> CGFloat{
        return self.cellHeight
    }

    func computeLabelHeight(_ text: String, _ textFont: UIFont, _ width: CGFloat) -> CGFloat {
        // A dummy label in order to compute dynamic height.
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = textFont
        
        label.preferredMaxLayoutWidth = width
        label.text = text
        label.invalidateIntrinsicContentSize()
        
        let height = label.intrinsicContentSize.height
        return height
    }
    
    // -- Button Function --
    //    tap the cell and go to editing page
    @objc func cellTapHandler(sender: UITapGestureRecognizer){
        // print (self.cellTag)
        let vc:UIViewController = self.getParentViewController()!
        let editVC:EditMode1VC = (vc.storyboard?.instantiateViewController(withIdentifier: "EditMode1VC"))! as! EditMode1VC
        editVC.configureData(type: "editting_education", data: cellData, editIndex: self.cellTag)
        vc.navigationController?.pushViewController(editVC, animated: true)
        editVC.delegate = vc as? SaveDataDelegate // --  Sending delegate to Edit View in order to return data

    }
    
    // Get Cell High
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
