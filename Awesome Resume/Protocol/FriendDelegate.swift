//
//  FriendDelegate.swift
//  Awesome Resume
//
//  Created by Hien Tran on 7/10/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

protocol FriendDelegate {
    func followFriendExecute(friendUserName: String, friendEmail: String, index: Int)
    func unfollowFriendExecute(friendUserName: String, friendEmail: String, index: Int)
}
