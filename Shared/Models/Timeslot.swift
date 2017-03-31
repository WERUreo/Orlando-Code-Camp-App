//
//  Timeslot.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Timeslot
{
    let startTime: String?
    let endTime: String?
    let rank: Int?
    let sessions: [Session]?

    init(startTime: String?, endTime: String?, rank: Int?, sessions: [Session]?)
    {
        self.startTime = startTime
        self.endTime = endTime
        self.rank = rank
        self.sessions = sessions
    }

    init(json: JSON)
    {
        self.startTime = json["startTime"].stringValue
        self.endTime = json["endTime"].stringValue
        self.rank = json["rank"].intValue
        self.sessions = nil
    }
}
