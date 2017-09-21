//
//  MediaViewCell.swift
//  Awesome Resume
//
//  Created by Hien Tran on 13/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class MediaViewCell: UITableViewCell {

    @IBOutlet weak var mediaInfoView: MediaInfoView!
    @IBOutlet weak var mediaContent: UIView!
    
    var playCallBack:((IndexPath?) -> Swift.Void)?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(user: User, media: Video) {
        self.mediaInfoView.configView(user: user, media: media)
    }

    @IBAction func startVideo(_ sender: Any) {
        if let callBack = playCallBack {
            callBack(indexPath)
        }
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
