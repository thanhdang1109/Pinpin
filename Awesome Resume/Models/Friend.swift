//
//  Friends.swift
//  Awesome Resume
//
//  Created by Hien Tran on 11/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

class Friend: Profile {
    var _userName: String?
    
    var _pictureUrl: String?
    
    var _email: String?
    
    var _videos: [Video]?
    
    var _location: String?
    
    var _followed: Bool!
    
    
    init(userName: String?, email: String?, pictureUrl: String?, location: String?, followed: Bool) {
        self._userName = userName
        self._email = email
        self._pictureUrl = pictureUrl
        self._videos = [Video]()
        self._location = location
        self._followed = followed
    }
}
