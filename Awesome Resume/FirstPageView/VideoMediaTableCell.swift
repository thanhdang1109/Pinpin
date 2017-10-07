//
//  VideoMediaTableCell.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 30/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import AVKit

class VideoMediaTableCell: UITableViewCell {

    @IBOutlet weak var mediaInfoView: VideoMediaTableCellInfoView!
    @IBOutlet weak var mediaContent: UIView!
    
    
    @IBOutlet weak var videoSnapshotImage: UIImageView!
    var playCallBack:((IndexPath?) -> Swift.Void)?
    var indexPath : IndexPath?
    var videoInfo: Video!
    
    @IBOutlet weak var CellOuterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(media: Video) {
//        self.CellOuterView.layer.masksToBounds = true
//        self.CellOuterView.layer.cornerRadius = 4.0
        self.videoInfo = media
//        self.videoSnapshotImage.image = videoSnapshot(filePathLocal: media._link! as NSString)
        self.mediaInfoView.configView(media: media)
        let selectCellGesture = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(selectCellGesture)
        
    }
    
    @objc func selectAction(sender: UITapGestureRecognizer){
        print(self.videoInfo._title!)
        print(self.videoInfo._description!)
        print(self.videoInfo._link!)
        print(self.videoInfo._fileName!)
    }
    
    @IBAction func startVideo(_ sender: Any) {
        if let callBack = playCallBack {
            callBack(indexPath)
        }
    }
    
    func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        /// Get Snapshot of a video
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    

}
