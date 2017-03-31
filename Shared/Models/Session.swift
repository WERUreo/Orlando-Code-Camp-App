//
//  Session.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

struct Session
{
    let name: String?
    let description: String?
    let level: Int? // 1 - All skill levels, 2 - Some prior knowledge needed, 3 - Deep Dive
    let speaker: Speaker?
    let cospeakers: [Speaker]?
    let track: Track?
    let timeslot: Timeslot?
}
