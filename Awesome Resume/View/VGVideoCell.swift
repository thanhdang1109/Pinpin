//
//  VGVideoCell.swift
//  Awesome Resume
//
//  Created by Hien Tran on 16/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class VGVideoCell: UITableViewCell {

    @IBOutlet weak var playBtn: UIButton!
    var playCallBack:((IndexPath?) -> Swift.Void)?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onPlay(_ sender: Any) {
        if let callBack = playCallBack {
            callBack(indexPath)
        }
    }
}
