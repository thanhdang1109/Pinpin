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
    
    init(userName: String?, email: String?, pictureUrl: String?) {
        self._userName = userName
        self._email = email
        self._pictureUrl = pictureUrl
        self._videos = [Video]()
    }
}
