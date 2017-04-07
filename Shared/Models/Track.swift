//
//  Track.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Track
{
    let name: String
    let roomNumber: String?
    let sessions: [Session]?

    init(name: String, roomNumber: String?, sessions: [Session]?)
    {
        self.name = name
        self.roomNumber = roomNumber
        self.sessions = sessions
    }

    init(json: JSON)
    {
        self.name = json["name"].stringValue
        self.roomNumber = json["roomNumber"].stringValue
        self.sessions = nil
    }
}
