//
//  VideoMediaTableCell.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 30/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class VideoMediaTableCell: UITableViewCell {

    @IBOutlet weak var mediaInfoView: VideoMediaTableCellInfoView!
    @IBOutlet weak var mediaContent: UIView!
    var playCallBack:((IndexPath?) -> Swift.Void)?
    var indexPath : IndexPath?
    var videoInfo: Video!
    
    
    @IBOutlet weak var CellOuterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(media: Video) {
        self.CellOuterView.layer.masksToBounds = true
        self.CellOuterView.layer.cornerRadius = 6.0
        self.videoInfo = media
        self.mediaInfoView.configView(media: media)
        let selectCellGesture = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(selectCellGesture)
    }
    
    @objc func selectAction(sender: UITapGestureRecognizer){
        print(self.videoInfo._title)
        print(self.videoInfo._description)
        print(self.videoInfo._link)
        print(self.videoInfo._fileName)
    }
    
    @IBAction func startVideo(_ sender: Any) {
        if let callBack = playCallBack {
            callBack(indexPath)
        }
    }
    

}
