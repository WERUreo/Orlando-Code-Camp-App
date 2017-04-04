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
    let time: String
    let rank: Int
    let sessions: [Session]?

    init(time: String, rank: Int, sessions: [Session]?)
    {
        self.time = time
        self.rank = rank
        self.sessions = sessions
    }

    init(json: JSON)
    {
        self.time = json["time"].stringValue
        self.rank = json["rank"].intValue
        self.sessions = nil
    }
}
