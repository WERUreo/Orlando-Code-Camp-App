//
//  Session.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SessionLevel: Int, CustomStringConvertible
{
    case allSkillLevels = 1
    case somePriorKnowledge
    case deepDive

    var description: String
    {
        switch self
        {
            case .allSkillLevels:
                return "All skill levels"
            case .somePriorKnowledge:
                return "Some prior knowledge needed"
            case .deepDive:
                return "Deep Dive"
        }
    }
}

struct Session
{
    let name: String
    let description: String
    let level: SessionLevel?
    var speaker: (name: String, avatarURL: String, title: String?, company: String?, twitter: String?)?
    let cospeakers: [(name: String, avatarURL: String)]?
    var track: (name: String, roomNumber: String)?
    let timeslot: (time: String, rank: Int)

    init(json: JSON)
    {
        let speaker = json["speaker"].first
        let track = json["track"].first
        let timeslot: (key: String, value: JSON) = json["timeslot"].first!

        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.level = SessionLevel(rawValue: json["level"].intValue)
        if let speaker = speaker
        {
            self.speaker = (name: speaker.1["name"].stringValue,
                            avatarURL: speaker.1["avatarURL"].stringValue,
                            title: speaker.1["title"].string,
                            company: speaker.1["company"].string,
                            twitter: speaker.1["twitter"].string)
        }
        if let track = track
        {
            self.track = (name: track.1["name"].stringValue, roomNumber: track.1["roomNumber"].stringValue)
        }
        self.cospeakers = nil
        self.timeslot = (time: timeslot.value["time"].stringValue, rank: timeslot.value["rank"].intValue)
    }
}
