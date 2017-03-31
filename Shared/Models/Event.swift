//
//  Event.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

struct Event
{
    let name: String
    let socialMediaHashtag: String
    let eventStart: Date
    let eventEnd: Date
    let completeAddress: String
    let isCurrent: Bool
    let attendeeRegistrationOpen: Bool?
    let speakerRegistrationOpen: Bool?
}
