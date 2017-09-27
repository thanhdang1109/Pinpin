//
//  MediaInfoView.swift
//  Awesome Resume
//
//  Created by Hien Tran on 13/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class MediaInfoView: UIView {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mediaDesc: UILabel!
    @IBOutlet weak var mediaTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(user: Profile, media: Video) {
        self.userName.text = user._userName
        self.mediaDesc.text = media._description
        self.mediaTime.text = media._time
    }

}
