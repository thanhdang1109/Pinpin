//
//  ResumesModel.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 8/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import Foundation

class ResumeContent {
    var titleArea: TitleInfo?
    var eduArea: [EducationInfo]?
    var expArea: [ExperienceInfo]?
}

class TitleInfo {
    var name: String?
    var address: String?
    var phone: String?
}

// Class for education information
class EducationInfo {
    var eduInstituteName: String?
    var eduDetails: [String]?
}

// Class for Experience information
class ExperienceInfo {
    var expDuration: String?
    var expCompany: String?
    var expLocation: String?
    var expDetails: [ExperienceInfoDetail]?
}

class ExperienceInfoDetail {
    var expPosition: String?
    var expDetails: [String]?
}










