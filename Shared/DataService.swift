//
//  DataService.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftyJSON

typealias GetAllSpeakersCompletion = (_ speakers: [Speaker]?, _ error: Error?) -> Void
typealias GetAllTracksCompletion = (_ tracks: [Track]?, _ error: Error?) -> Void
typealias GetAllTimeslotsCompletion = (_ timeslot: [Timeslot]?, _ error: Error?) -> Void

class DataService: NSObject
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    static let shared = DataService()
    fileprivate let databaseRef = FIRDatabase.database().reference()

    ////////////////////////////////////////////////////////////
    // MARK: - Initlializer
    ////////////////////////////////////////////////////////////

    private override init() {}

    ////////////////////////////////////////////////////////////
    // MARK: - Request Functions
    ////////////////////////////////////////////////////////////

    func getAllSpeakers(completion: @escaping GetAllSpeakersCompletion)
    {
        let speakersRef = databaseRef.child("speakers")
        speakersRef.observeSingleEvent(of: .value, with:
        { snapshot in
            var speakers = [Speaker]()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let speakerDict = snap.value as? [String: Any]
                    {
                        let speakerJSON = JSON(speakerDict)
                        let speaker = Speaker(json: speakerJSON)
                        speakers.append(speaker)
                    }
                }
                completion(speakers, nil)
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func getAllTracks(completion: @escaping GetAllTracksCompletion)
    {
        let tracksRef = databaseRef.child("tracks")
        tracksRef.observeSingleEvent(of: .value, with:
        { snapshot in
            var tracks = [Track]()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let trackDict = snap.value as? [String: Any]
                    {
                        let trackJSON = JSON(trackDict)
                        let track = Track(json: trackJSON)
                        tracks.append(track)
                    }
                }
                completion(tracks, nil)
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func getAllTimeslots(completion: @escaping GetAllTimeslotsCompletion)
    {
        let timeslotsRef = databaseRef.child("timeslots")
        timeslotsRef.observeSingleEvent(of: .value, with:
        { snapshot in
            var timeslots = [Timeslot]()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let timeslotDict = snap.value as? [String: Any]
                    {
                        let timeslotJSON = JSON(timeslotDict)
                        let timeslot = Timeslot(json: timeslotJSON)
                        timeslots.append(timeslot)
                    }
                }
                completion(timeslots, nil)
            }
        })
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Save Functions
    ////////////////////////////////////////////////////////////

    func saveSpeaker(_ speaker: Speaker, completion: () -> Void)
    {
        let speakersRef = databaseRef.child("speakers")
        let key = speakersRef.childByAutoId()

        if let fullName = speaker.fullName, fullName != "" { key.child("fullName").setValue(fullName) }
        if let company = speaker.company, company != "" { key.child("company").setValue(company) }
        if let title = speaker.title, title != "" { key.child("title").setValue(title) }
        if let bio = speaker.bio, bio != "" { key.child("bio").setValue(bio) }
        if let twitter = speaker.twitter, twitter != "" { key.child("twitter").setValue(twitter) }
        if let website = speaker.website, website != "" { key.child("website").setValue(website) }
        if let blog = speaker.blog, blog != "" { key.child("blog").setValue(blog) }
        if let avatarURL = speaker.avatarURL, avatarURL != "" { key.child("avatarURL").setValue(avatarURL) }
        if let mvpDetails = speaker.mvpDetails, mvpDetails != "" { key.child("mvpDetails").setValue(mvpDetails) }
        if let authorDetails = speaker.authorDetails, authorDetails != "" { key.child("authorDetails").setValue(authorDetails) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveTrack(_ track: Track, completion: () -> Void)
    {
        let tracksRef = databaseRef.child("tracks")
        let key = tracksRef.childByAutoId()

        if let trackName = track.name, trackName != "" { key.child("name").setValue(trackName) }
        if let roomNumber = track.roomNumber, roomNumber != "" { key.child("roomNumber").setValue(roomNumber) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveTimeSlot(_ timeslot: Timeslot, completion: () -> Void)
    {
        let timeslotsRef = databaseRef.child("timeslots")
        let key = timeslotsRef.childByAutoId()

        if let startTime = timeslot.startTime, startTime != "" { key.child("startTime").setValue(startTime) }
        if let endTime = timeslot.endTime, endTime != "" { key.child("endTime").setValue(endTime) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveSponsor(_ sponsor: Sponsor, completion: () -> Void)
    {
        let sponsorsRef = databaseRef.child("sponsors")
        let key = sponsorsRef.childByAutoId()

        if let companyName = sponsor.companyName, companyName != "" { key.child("companyName").setValue(companyName) }
        if let sponsorLevel = sponsor.sponsorLevel, sponsorLevel != "" { key.child("sponsorLevel").setValue(sponsorLevel) }
        if let bio = sponsor.bio, bio != "" { key.child("bio").setValue(bio) }
        if let twitter = sponsor.twitter, twitter != "" { key.child("twitter").setValue(twitter) }
        if let website = sponsor.website, website != "" { key.child("website").setValue(website) }
        if let avatarURL = sponsor.avatarURL, avatarURL != "" { key.child("avatarURL").setValue(avatarURL) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveSession(_ session: Session, completion: () -> Void)
    {
        let sessionsRef = databaseRef.child("sessions")
        let newSessionRef = sessionsRef.childByAutoId()
        let key = newSessionRef.key

        if let name = session.name, name != "" { newSessionRef.child("name").setValue(name) }
        if let description = session.description, description != "" { newSessionRef.child("description").setValue(description) }
        if let level = session.level { newSessionRef.child("level").setValue(level) }
        if let speaker = session.speaker
        {
            getSpeakerKey(speaker, completion:
            { speakerKey in
                newSessionRef.child("speaker").setValue(speakerKey)
                self.updateSpeaker(key: speakerKey!, withSession: key)
            })
        }
        if let cospeakers = session.cospeakers
        {
            for speaker in cospeakers
            {
                getSpeakerKey(speaker, completion:
                { speakerKey in
                    newSessionRef.child("cospeakers").child(speakerKey!).setValue(true)
                    self.updateSpeaker(key: speakerKey!, withSession: key)
                })
            }
        }
        if let track = session.track
        {
            getTrackKey(track, completion:
            { trackKey in
                newSessionRef.child("track").setValue(trackKey)
                self.updateTrack(key: trackKey!, withSession: key)
            })
        }
        if let timeslot = session.timeslot
        {
            getTimeslotKey(timeslot, completion:
            { timeslotKey in
                newSessionRef.child("timeslot").setValue(timeslotKey)
                self.updateTimeslot(key: timeslotKey!, withSession: key)
            })
        }
        completion()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Private Functions
    ////////////////////////////////////////////////////////////

    private func getSpeakerKey(_ speaker: Speaker, completion: @escaping (String?) -> Void)
    {
        guard let name = speaker.fullName else
        {
            completion(nil)
            return
        }

        let speakersRef = databaseRef.child("speakers")
        let query = speakersRef.queryOrdered(byChild: "fullName").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
            { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                {
                    completion(snapshots.first?.key)
                }
        })
    }

    ////////////////////////////////////////////////////////////

    private func getTrackKey(_ track: Track, completion: @escaping (String?) -> Void)
    {
        guard let name = track.name else
        {
            completion(nil)
            return
        }

        let tracksRef = databaseRef.child("tracks")
        let query = tracksRef.queryOrdered(byChild: "name").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
            { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                {
                    completion(snapshots.first?.key)
                }
        })
    }

    ////////////////////////////////////////////////////////////

    private func getTimeslotKey(_ timeslot: Timeslot, completion: @escaping (String?) -> Void)
    {
        guard let startTime = timeslot.startTime else
        {
            completion(nil)
            return
        }

        let timeslotsRef = databaseRef.child("timeslots")
        let query = timeslotsRef.queryOrdered(byChild: "startTime").queryEqual(toValue: startTime)
        query.observeSingleEvent(of: .value, with:
            { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                {
                    completion(snapshots.first?.key)
                }
        })
    }

    ////////////////////////////////////////////////////////////

    private func updateSpeaker(key: String, withSession sessionKey: String)
    {
        let childUpdates =
        [
            "/speakers/\(key)/sessions/\(sessionKey)/": true
        ]
        databaseRef.updateChildValues(childUpdates)
    }

    ////////////////////////////////////////////////////////////

    private func updateTrack(key: String, withSession sessionKey: String)
    {
        let childUpdates =
        [
            "/tracks/\(key)/sessions/\(sessionKey)/": true
        ]
        databaseRef.updateChildValues(childUpdates)
    }

    ////////////////////////////////////////////////////////////
    
    private func updateTimeslot(key: String, withSession sessionKey: String)
    {
        let childUpdates =
        [
            "/timeslots/\(key)/sessions/\(sessionKey)/": true
        ]
        databaseRef.updateChildValues(childUpdates)
    }
}
