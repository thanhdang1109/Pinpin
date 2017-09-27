//
//  FollowFriendCell.swift
//  Awesome Resume
//
//  Created by Hien Tran on 26/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class FollowFriendCell: UITableViewCell {
    
    @IBOutlet weak var friendUsrImg: UIImageView!
    @IBOutlet weak var friendUsrName: UILabel!
    @IBOutlet weak var friendUsrLocation: UILabel!
    @IBOutlet weak var friendFollowBtn: CorneredButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(friend: Friend) {
        self.friendUsrName.text = friend._userName
        self.friendUsrLocation.text = friend._location
    }
    
    @IBAction func friendFollowBtnClicked(_ sender: Any) {
        print("Follow Pressed!")
    }
}
