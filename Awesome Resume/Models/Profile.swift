//
//  Profile.swift
//  Awesome Resume
//
//  Created by Hien Tran on 11/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

protocol Profile {
    var _userName: String? {get}
    var _pictureUrl: String? {get}
    var _email: String? {get}
    var _videos: [Video]? {get}
    var _location: String? {get}
}
