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
    let level: SessionLevel
    var speaker: (name: String, avatarURL: String)
    let cospeakers: [(name: String, avatarURL: String)]?
    var track: (name: String, roomNumber: String)
    let timeslot: String

    init(json: JSON)
    {
        let speaker: (key: String, value: JSON) = json["speaker"].first!
        let track: (key: String, value: JSON) = json["track"].first!
        let timeslot: (key: String, value: JSON) = json["timeslot"].first!

        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.level = SessionLevel(rawValue: json["level"].intValue)!
        self.speaker = (name: speaker.value["fullName"].stringValue, avatarURL: speaker.value["avatarURL"].stringValue)
        self.track = (name: track.value["name"].stringValue, roomNumber: track.value["roomNumber"].stringValue)
        self.cospeakers = nil
        self.timeslot = timeslot.value["time"].stringValue
    }
}
