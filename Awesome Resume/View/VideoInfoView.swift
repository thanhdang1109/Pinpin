//
//  VideoInfoView.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 29/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class VideoInfoView: UIView {
    
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var VideoDesc: UILabel!
    @IBOutlet weak var VideoTimestamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(user: Profile, media: Video) {
        self.UserName.text = user._userName
        self.VideoDesc.text = media._description
        self.VideoTimestamp.text = media._time
    }
    
}

