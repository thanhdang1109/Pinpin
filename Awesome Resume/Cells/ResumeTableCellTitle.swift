//
//  ResumeTableCellTitle.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 10/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumeTableCellTitle: UITableViewCell {
    
    @IBOutlet weak var titleCellTextField: UITextField?
    @IBOutlet weak var titleCellTextView: UITextView?
    
    func configCell(data: [String: String]) {
        self.titleCellTextField?.text = data["name"]
        self.titleCellTextView?.text = data["addr"]
    }
    
    override func awakeFromNib() {
        titleCellTextField?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
