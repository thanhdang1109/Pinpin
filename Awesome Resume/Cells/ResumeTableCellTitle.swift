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
    
    func configCell(name: String, address: String) {
        self.titleCellTextField?.text = name
        self.titleCellTextView?.text = address
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
