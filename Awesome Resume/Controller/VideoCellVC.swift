//
//  VideoCellVC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 13/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoCellVC: UITableViewCell {
    
    @IBOutlet weak var VideoCellLabel: UILabel!
    @IBOutlet weak var VideoCellPlayer: UIView!
    var VideoURL: String!
    
    var avPlayerViewController:AVPlayerViewController?
    var avPlayer: AVPlayer?
    var fileURL: URL?
    var videoLayer: AVPlayerLayer?
    

    func setURL(videoUrl: String){
        print(videoUrl)
        fileURL = URL.init(fileURLWithPath: videoUrl)
        avPlayer = AVPlayer(url: fileURL as! URL)
        videoLayer = AVPlayerLayer(player: avPlayer)
        videoLayer?.frame = self.bounds
        videoLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(videoLayer!)
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
