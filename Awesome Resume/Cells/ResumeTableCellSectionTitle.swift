//
//  ResumeTableCellSectionTitle.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 11/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumeTableCellSectionTitle: UITableViewCell {
    
    @IBOutlet weak var TableCellSectionTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func addNewView(_ sender: Any) {
        let uiLabel = UILabel()
        uiLabel.text = "Testing"
        stackView.insertArrangedSubview(uiLabel, at: 0)
        uiLabel.frame.size.height = 40
        
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
