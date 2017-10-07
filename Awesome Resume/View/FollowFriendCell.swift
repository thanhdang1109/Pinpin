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
    
    var index: Int!
    var friendDelegate: FriendDelegate!

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
        self.friendUsrLocation.text = friend._email
        if friend._followed {
            print("Followed!")
            setBtn(btn: self.friendFollowBtn, backGroundColorNew: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "- Unfollow")
        } else {
            print("Unfollowed!")
            setBtn(btn: self.friendFollowBtn, backGroundColorNew: #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "+ Follow")
        }
    }
    
    func setBtn(btn: UIButton, backGroundColorNew: UIColor, textColor: UIColor, text: String) {
        btn.setTitle(text, for: .normal)
        btn.backgroundColor = backGroundColorNew
        btn.setTitleColor(textColor, for: .normal)
    }
    
    @IBAction func friendFollowBtnClicked(_ sender: Any) {
//        print("Follow Pressed!")
        let btn = sender as! UIButton
        if btn.titleLabel?.text == "+ Follow" {
            friendDelegate.followFriendExecute(friendUserName: self.friendUsrName.text!, friendEmail: "", index: self.index)
            return
        }
        friendDelegate.unfollowFriendExecute(friendUserName: self.friendUsrName.text!, friendEmail: "", index: self.index)
    }
}
