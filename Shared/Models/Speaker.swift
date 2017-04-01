//
//  Speaker.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Speaker
{
    let fullName: String
    let company: String?
    let title: String?
    let bio: String?
    let twitter: String?
    let website: String?
    let blog: String?
    let avatarURL: String
    let mvpDetails: String?
    let authorDetails: String?
    let sessions: [Session]?

//    init(fullName: String?, company: String?, title: String?, bio: String?, twitter: String?, website: String?, blog: String?, avatarURL: String?, mvpDetails: String?, authorDetails: String?, sessions: [Session]?)
//    {
//        self.fullName = fullName
//        self.company = company
//        self.title = title
//        self.bio = bio
//        self.twitter = twitter
//        self.website = website
//        self.blog = blog
//        self.avatarURL = avatarURL
//        self.mvpDetails = mvpDetails
//        self.authorDetails = authorDetails
//        self.sessions = sessions
//    }

    init(json: JSON)
    {
        self.fullName = json["fullName"].stringValue
        self.company = json["company"].stringValue
        self.title = json["title"].stringValue
        self.bio = json["bio"].stringValue
        self.twitter = json["twitter"].stringValue
        self.website = json["website"].stringValue
        self.blog = json["blog"].stringValue
        self.avatarURL = json["avatarURL"].stringValue
        self.mvpDetails = json["mvpDetails"].stringValue
        self.authorDetails = json["authorDetails"].stringValue
        self.sessions = nil
    }
}
