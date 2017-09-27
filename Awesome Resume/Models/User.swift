//
//  User.swift
//  Awesome Resume
//
//  Created by Hien Tran on 12/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

class User: Profile {
    var _location: String?
    
    var _userName: String?
    
    var _pictureUrl: String?
    
    var _email: String?
    
    var _videos: [Video]?
    
    var _friends: [Friend]?
    
    init(userName: String?, email: String?, pictureUrl: String?, location: String?) {
        self._userName = userName
        self._email = email
        self._pictureUrl = pictureUrl
        self._videos = [Video]()
        self._friends = [Friend]()
        self._location = location
    }
}
