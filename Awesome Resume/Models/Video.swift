//
//  Video.swift
//  Awesome Resume
//
//  Created by Hien Tran on 12/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

class Video {
    var _title: String?
    var _description: String?
    var _time: String?
    var _link: String?
    
    init(title: String?, description: String?, time: String?, link: String?) {
        self._title = title
        self._description = description
        self._time = time
        self._link = link
    }
}
