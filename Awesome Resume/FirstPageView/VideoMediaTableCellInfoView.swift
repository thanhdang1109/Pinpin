//
//  VideoMediaTableCellInfoView.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 30/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class VideoMediaTableCellInfoView: UIView {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DescLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(media: Video) {
        self.TitleLabel.text = media._title?.uppercased()
        self.DateLabel.text = media._time
        self.DescLabel.text = media._description
    }


}
