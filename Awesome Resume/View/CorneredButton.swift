//
//  CorneredButton.swift
//  Awesome Resume
//
//  Created by Hien Tran on 3/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class CorneredButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

}
