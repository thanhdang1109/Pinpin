//
//  ExpSectionCell.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 20/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ExpSectionCell: UITableViewCell {

    @IBOutlet weak var expOrgan: UILabel!
    
    func configCell(data: [String: String]) {
        self.expOrgan?.text = data["organization"]
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
