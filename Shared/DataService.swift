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
import Alamofire
import AlamofireImage

typealias GetAllSpeakersCompletion = (_ speakers: [Speaker]?, _ error: Error?) -> Void
typealias GetAllTracksCompletion = (_ tracks: [Track]?, _ error: Error?) -> Void
typealias GetAllTimeslotsCompletion = (_ timeslot: [Timeslot]?, _ error: Error?) -> Void
typealias GetAllSessionsCompletion = (_ session: [Session]?, _ error: Error?) -> Void

typealias GetTrackWithKeyCompletion = (_ track: Track) -> Void
typealias GetTimeslotWithKeyCompletion = (_ timeslot: Timeslot) -> Void
typealias GetSpeakerWithKeyCompletion = (_ speaker: Speaker) -> Void
typealias GetSpeakerImageCompletion = (_ image: UIImage?) -> Void

class DataService: NSObject
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    static let shared = DataService()
    fileprivate let databaseRef = FIRDatabase.database().reference()
    fileprivate let imageCache = AutoPurgingImageCache()

    static let kSessionsKey         = "sessions"
    static let kSpeakersKey         = "speakers"
    static let kTracksKey           = "tracks"
    static let kTimeslotsKey        = "timeslots"
    static let kDefaultAvatarURL    = "http://orlandocodecamp.com/images/default_user_icon.jpg"

    ////////////////////////////////////////////////////////////
    // MARK: - Initlializer
    ////////////////////////////////////////////////////////////

    private override init() {}

    ////////////////////////////////////////////////////////////
    // MARK: - Request Functions
    ////////////////////////////////////////////////////////////

    func getAllSpeakers(completion: @escaping GetAllSpeakersCompletion)
    {
        let speakersRef = databaseRef.child(DataService.kSpeakersKey)
        speakersRef.observe(.value, with:
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
        let tracksRef = databaseRef.child(DataService.kTracksKey)
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
        let timeslotsRef = databaseRef.child(DataService.kTimeslotsKey)
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

    func getAllSessions(completion: @escaping GetAllSessionsCompletion)
    {
        let sessionsRef = databaseRef.child(DataService.kSessionsKey)
        sessionsRef.observe(.value, with:
        { snapshot in
            var sessions = [Session]()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let sessionDict = snap.value as? [String: Any]
                    {
                        let sessionJSON = JSON(sessionDict)
                        let session = Session(json: sessionJSON)
                        sessions.append(session)
                    }
                }
                completion(sessions, nil)
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func getTrack(withKey key: String, completion: @escaping GetTrackWithKeyCompletion)
    {
        let tracksRef = databaseRef.child(DataService.kTracksKey)
        tracksRef.child(key).observeSingleEvent(of: .value, with:
        { snapshot in
            print(snapshot.value ?? "Nothing")
        })
    }

    ////////////////////////////////////////////////////////////

    func getSpeaker(withKey key: String, completion: @escaping GetSpeakerWithKeyCompletion)
    {
        let speakersRef = databaseRef.child(DataService.kSpeakersKey)
        speakersRef.child(key).observeSingleEvent(of: .value, with:
        { snapshot in
            if let value = snapshot.value as? [String: Any]
            {
                let json = JSON(value)
                let speaker = Speaker(json: json)
                completion(speaker)
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func getSpeakerImage(from url: String, completion: @escaping GetSpeakerImageCompletion)
    {
        if let cachedImage = self.imageCache.image(withIdentifier: url)
        {
            completion(cachedImage)
        }
        else
        {
            Alamofire.request(url).responseImage
            { response in
                if response.result.isSuccess
                {
                    guard let image = response.result.value else
                    {
                        completion(nil)
                        return
                    }

                    self.imageCache.add(image, withIdentifier: url)
                    completion(image)
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func getSession(withName name: String)
    {
        let sessionsRef = databaseRef.child(DataService.kSessionsKey)
        let query = sessionsRef.queryOrdered(byChild: "name").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                print(snapshots.first?.value ?? "Nothing")
            }
        })
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Save Functions
    ////////////////////////////////////////////////////////////

    func saveSpeaker(name: String, title: String?, company: String?, bio: String?, twitter: String?, website: String?, blog: String?, avatarURL: String = DataService.kDefaultAvatarURL, mvpDetails: String?, authorDetails: String?, completion: @escaping () -> Void)
    {
        let speakersRef = self.databaseRef.child(DataService.kSpeakersKey)
        let query = speakersRef.queryOrdered(byChild: "fullName").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            var key = ""
            var childUpdates = [AnyHashable: Any]()
            if snapshot.exists()
            {
                if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot],
                   let speaker = snaps.first
                {
                    key = speaker.key
                    let sessionsSnap = speaker.childSnapshot(forPath: "sessions/")
                    if let sessions = sessionsSnap.children.allObjects as? [FIRDataSnapshot]
                    {
                        sessions.forEach
                        {
                            let sessionKey = $0.key
                            childUpdates["/sessions/\(sessionKey)/speaker/\(key)/name/"] = name
                            childUpdates["/sessions/\(sessionKey)/speaker/\(key)/title/"] = title as Any
                            childUpdates["/sessions/\(sessionKey)/speaker/\(key)/company/"] = company as Any
                            childUpdates["/sessions/\(sessionKey)/speaker/\(key)/twitter/"] = twitter as Any
                            childUpdates["/sessions/\(sessionKey)/speaker/\(key)/avatarURL/"] = avatarURL

                            let sessionsRef = self.databaseRef.child(DataService.kSessionsKey)
                            let query = sessionsRef.queryOrderedByKey().queryEqual(toValue: $0.key)
                            query.observeSingleEvent(of: .value, with:
                            { snapshot in
                                if let sessionsSnap = snapshot.children.allObjects as? [FIRDataSnapshot],
                                   let session = sessionsSnap.first
                                {
                                    let nameSnap = session.childSnapshot(forPath: "name")
                                    if let nameValue = nameSnap.value
                                    {
                                        let updates: [AnyHashable: Any] = ["/speakers/\(key)/sessions/\(sessionKey)/name/":nameValue]
                                        self.databaseRef.updateChildValues(updates)
                                    }
                                }
                            })
                        }
                    }
                }
                else
                {
                    // We should never reach this case.  This would mean that somehow, there is a speaker with the fullName we passed in, but at the same time there isn't....
                    completion()
                    return
                }
            }
            else
            {
                key = speakersRef.childByAutoId().key
            }

            childUpdates["/speakers/\(key)/fullName/"] = name
            childUpdates["/speakers/\(key)/title/"] = title as Any
            childUpdates["/speakers/\(key)/company/"] = company as Any
            childUpdates["/speakers/\(key)/bio/"] = bio as Any
            childUpdates["/speakers/\(key)/twitter/"] = twitter as Any
            childUpdates["/speakers/\(key)/website/"] = website as Any
            childUpdates["/speakers/\(key)/blog/"] = blog as Any
            childUpdates["/speakers/\(key)/avatarURL/"] = avatarURL
            childUpdates["/speakers/\(key)/mvpDetails/"] = mvpDetails as Any
            childUpdates["/speakers/\(key)/authorDetails/"] = authorDetails as Any
            self.databaseRef.updateChildValues(childUpdates)
            completion()
        })
    }

    ////////////////////////////////////////////////////////////

    func saveSpeaker(_ speaker: Speaker?, completion: () -> Void)
    {
        let speakersRef = databaseRef.child(DataService.kSpeakersKey)
        let key = speakersRef.childByAutoId()

        key.child("fullName").setValue("temp")
//        key.child("fullName").setValue(speaker.fullName)
//        if let company = speaker.company, company != "" { key.child("company").setValue(company) }
//        if let title = speaker.title, title != "" { key.child("title").setValue(title) }
//        if let bio = speaker.bio, bio != "" { key.child("bio").setValue(bio) }
//        if let twitter = speaker.twitter, twitter != "" { key.child("twitter").setValue(twitter) }
//        if let website = speaker.website, website != "" { key.child("website").setValue(website) }
//        if let blog = speaker.blog, blog != "" { key.child("blog").setValue(blog) }
//        key.child("avatarURL").setValue(speaker.avatarURL)
//        if let mvpDetails = speaker.mvpDetails, mvpDetails != "" { key.child("mvpDetails").setValue(mvpDetails) }
//        if let authorDetails = speaker.authorDetails, authorDetails != "" { key.child("authorDetails").setValue(authorDetails) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveTrack(name: String, roomNumber: String, completion: @escaping () -> Void)
    {
        let tracksRef = self.databaseRef.child(DataService.kTracksKey)
        let query = tracksRef.queryOrdered(byChild: "name").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot],
               let track = snaps.first
            {
//                let sessionsSnap = track.childSnapshot(forPath: "sessions/")
//                if let sessions = sessionsSnap.children.allObjects as? [FIRDataSnapshot]
//                {
//                    sessions.forEach { print($0.key) }
//                }
                if let trackSnaps = track.children.allObjects as? [FIRDataSnapshot]
                {
                    for trackSnap in trackSnaps
                    {
                        if trackSnap.key == "sessions"
                        {
                            if let sessions = trackSnap.children.allObjects as? [FIRDataSnapshot]
                            {
                                var childUpdates = [AnyHashable: Any]()
                                for session in sessions
                                {
//                                    childUpdates["/\(DataService.kTracksKey)/\(track.key)/\(DataService.kSessionsKey)/\(session.key)/name/"] = session.value
                                    childUpdates["/\(DataService.kSessionsKey)/\(session.key)/track/\(track.key)/roomNumber/"] = roomNumber
                                }
                                self.databaseRef.updateChildValues(childUpdates)
                            }
                        }
                    }
                }
                print(track)
                if let value = track.value as? [String: Any]
                {
                    if let temp = value["sessions"] as? [String: Any]
                    {
                        print(temp)
                    }
                }
                let childUpdates =
                [
                    "/tracks/\(track.key)/roomNumber/": roomNumber
                ]

                self.databaseRef.updateChildValues(childUpdates)
                completion()
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func saveTrack(_ track: Track, completion: () -> Void)
    {
//        let tracksRef = databaseRef.child("tracks")
//        let key = tracksRef.childByAutoId()
//
//        if let trackName = track.name, trackName != "" { key.child("name").setValue(trackName) }
//        if let roomNumber = track.roomNumber, roomNumber != "" { key.child("roomNumber").setValue(roomNumber) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveTimeSlot(_ timeslot: Timeslot, completion: () -> Void)
    {
        let timeslotsRef = databaseRef.child(DataService.kTimeslotsKey)
        let key = timeslotsRef.childByAutoId()

        key.child("time").setValue(timeslot.time)
        key.child("rank").setValue(timeslot.rank)
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveSponsor(_ sponsor: Sponsor, completion: () -> Void)
    {
//        let sponsorsRef = databaseRef.child("sponsors")
//        let key = sponsorsRef.childByAutoId()
//
//        if let companyName = sponsor.companyName, companyName != "" { key.child("companyName").setValue(companyName) }
//        if let sponsorLevel = sponsor.sponsorLevel, sponsorLevel != "" { key.child("sponsorLevel").setValue(sponsorLevel) }
//        if let bio = sponsor.bio, bio != "" { key.child("bio").setValue(bio) }
//        if let twitter = sponsor.twitter, twitter != "" { key.child("twitter").setValue(twitter) }
//        if let website = sponsor.website, website != "" { key.child("website").setValue(website) }
//        if let avatarURL = sponsor.avatarURL, avatarURL != "" { key.child("avatarURL").setValue(avatarURL) }
        completion()
    }

    ////////////////////////////////////////////////////////////

    func saveSession(name: String, description: String, level: Int, completion: @escaping () -> Void)
    {
        let sessionsRef = self.databaseRef.child(DataService.kSessionsKey)
        let query = sessionsRef.queryOrdered(byChild: "name").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            var key = ""
            var childUpdates = [AnyHashable: Any]()
            if snapshot.exists()
            {
                if let sessionSnaps = snapshot.children.allObjects as? [FIRDataSnapshot],
                   let session = sessionSnaps.first
                {
                    key = session.key
                }
                else
                {
                    completion()
                    return
                }
            }
            else
            {
                key = sessionsRef.childByAutoId().key
            }

            childUpdates["/sessions/\(key)/name/"] = name
            childUpdates["/sessions/\(key)/description/"] = description
            childUpdates["/sessions/\(key)/level/"] = level
            childUpdates["/sessions/\(key)/speaker"] = "temp"
            childUpdates["/sessions/\(key)/timeslot"] = "temp"
            childUpdates["/sessions/\(key)/track"] = "temp"
            self.databaseRef.updateChildValues(childUpdates)
            completion()
        })
    }

    ////////////////////////////////////////////////////////////

    func saveSession(_ session: Session?, completion: () -> Void)
    {
        let sessionsRef = databaseRef.child(DataService.kSessionsKey)
        let newSessionRef = sessionsRef.childByAutoId()
        newSessionRef.child("name").setValue("temp")
//        let key = newSessionRef.key
//
//        if let name = session.name, name != "" { newSessionRef.child("name").setValue(name) }
//        if let description = session.description, description != "" { newSessionRef.child("description").setValue(description) }
//        if let level = session.level { newSessionRef.child("level").setValue(level) }
//        if let speaker = session.speaker
//        {
//            getSpeakerKey(speaker, completion:
//            { speakerKey in
//                newSessionRef.child("speaker").setValue(speakerKey)
//                self.updateSpeaker(key: speakerKey!, withSession: key)
//            })
//        }
//        if let cospeakers = session.cospeakers
//        {
//            for speaker in cospeakers
//            {
//                getSpeakerKey(speaker, completion:
//                { speakerKey in
//                    newSessionRef.child("cospeakers").child(speakerKey!).setValue(true)
//                    self.updateSpeaker(key: speakerKey!, withSession: key)
//                })
//            }
//        }
//        if let track = session.track
//        {
//            getTrackKey(track, completion:
//            { trackKey in
//                newSessionRef.child("track").setValue(trackKey)
//                self.updateTrack(key: trackKey!, withSession: key)
//            })
//        }
//        if let timeslot = session.timeslot
//        {
//            getTimeslotKey(timeslot, completion:
//            { timeslotKey in
//                newSessionRef.child("timeslot").setValue(timeslotKey)
//                self.updateTimeslot(key: timeslotKey!, withSession: key)
//            })
//        }
        completion()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Delete Functions
    ////////////////////////////////////////////////////////////

    func deleteSpeaker(_ name: String, completion: () -> Void)
    {
        let speakersRef = self.databaseRef.child(DataService.kSpeakersKey)
        let query = speakersRef.queryOrdered(byChild: "fullName").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot],
               let speaker = snaps.first
            {
                print(speaker.key)
            }
        })
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Private Functions
    ////////////////////////////////////////////////////////////

    private func getSpeakerKey(_ speaker: Speaker, completion: @escaping (String?) -> Void)
    {
        let speakersRef = self.databaseRef.child(DataService.kSpeakersKey)
        let query = speakersRef.queryOrdered(byChild: "fullName").queryEqual(toValue: speaker.fullName)
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
        let tracksRef = databaseRef.child(DataService.kTracksKey)
        let query = tracksRef.queryOrdered(byChild: "name").queryEqual(toValue: track.name)
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
//        guard let startTime = timeslot.startTime else
//        {
//            completion(nil)
//            return
//        }
//
//        let timeslotsRef = databaseRef.child(DataService.kTimeslotsKey)
//        let query = timeslotsRef.queryOrdered(byChild: "startTime").queryEqual(toValue: startTime)
//        query.observeSingleEvent(of: .value, with:
//            { snapshot in
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
//                {
//                    completion(snapshots.first?.key)
//                }
//        })
    }

    ////////////////////////////////////////////////////////////

    func updateSessionSpeaker(key: String, inSession sessionName: String)
    {
        let sessionsRef = databaseRef.child(DataService.kSessionsKey)
        let query = sessionsRef.queryOrdered(byChild: "name").queryEqual(toValue: sessionName)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                let sessionKey = snapshots.first?.key
                self.getSpeaker(withKey: key)
                { speaker in
                    let childUpdates = ["/sessions/\(sessionKey!)/speaker/\(key)/name/": speaker.fullName,
                                        "/sessions/\(sessionKey!)/speaker/\(key)/avatarURL/": speaker.avatarURL]
                    self.databaseRef.updateChildValues(childUpdates)
                }
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func updateSession(_ sessionName: String, withTrack trackKey: String)
    {
        let tracksRef = databaseRef.child(DataService.kTracksKey)
        let trackQuery = tracksRef.queryOrderedByKey().queryEqual(toValue: trackKey)
        trackQuery.observeSingleEvent(of: .value, with:
        { snapshot in
            if let tracks = snapshot.value as? [String: Any]
            {
                let tracksJSON = JSON(tracks)
                if let track = tracksJSON[trackKey].dictionaryObject
                {
                    let trackName = JSON(track)["name"].stringValue
                    let sessionsRef = self.databaseRef.child("sessions")
                    let query = sessionsRef.queryOrdered(byChild: "name").queryEqual(toValue: sessionName)
                    query.observeSingleEvent(of: .value, with:
                    { snapshot in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                        {
                            let sessionKey = snapshots.first?.key
                            let childUpdates =
                                [
                                    "/sessions/\(sessionKey!)/track/\(trackKey)/": trackName
                            ]
                            self.databaseRef.updateChildValues(childUpdates)
                        }
                    })
                }
            }
            else
            {
                print("Nope")
            }
//            let trackName = track["name"] as! String
//            print(trackName)
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

    func updateAllSessions()
    {
//        let sessionsRef = databaseRef.child(DataService.kSessionsKey)
//        sessionsRef.observeSingleEvent(of: .value, with:
//        { snapshot in
//            if let sessions = snapshot.children.allObjects as? [FIRDataSnapshot]
//            {
//                for session in sessions
//                {
//                    if let sessionObject = session.value as? [String: Any]
//                    {
//                        if let speaker = sessionObject["speaker"] as? [String: Any]
//                        {
//                            if let key = speaker.first?.key
//                            {
//                                let speakersRef = self.databaseRef.child("speakers")
//                                let query = speakersRef.queryOrderedByKey().queryEqual(toValue: key)
//                                query.observeSingleEvent(of: .value, with:
//                                { snapshot in
//                                    if let speakers = snapshot.children.allObjects as? [FIRDataSnapshot]
//                                    {
//                                        for speakerSnap in speakers
//                                        {
//                                            if let speakerObject = speakerSnap.value as? [String: Any]
//                                            {
//                                                var childUpdates = [AnyHashable: Any]()
//                                                if let twitter = speakerObject["twitter"] as? String
//                                                {
//                                                    childUpdates["/sessions/\(session.key)/speaker/\(key)/twitter/"] = twitter
//                                                }
//                                                if let title = speakerObject["title"] as? String
//                                                {
//                                                    childUpdates["/sessions/\(session.key)/speaker/\(key)/title/"] = title
//                                                }
//                                                if let company = speakerObject["company"] as? String
//                                                {
//                                                    childUpdates["/sessions/\(session.key)/speaker/\(key)/company/"] = company
//                                                }
//
//                                                if !childUpdates.isEmpty
//                                                {
//                                                    self.databaseRef.updateChildValues(childUpdates)
//                                                }
//                                            }
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    }
//                }
//            }
//        })
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Search Functions
    ////////////////////////////////////////////////////////////

    func findSession(withName name: String, completion: @escaping (String) -> Void)
    {
        let sessionsRef = self.databaseRef.child(DataService.kSessionsKey)
        let query = sessionsRef.queryOrdered(byChild: "name").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if !snapshot.exists()
            {
                completion("This session doesn't exist")
            }
            else
            {
                completion("This session does exist")
            }
        })
    }

    ////////////////////////////////////////////////////////////

    func findSpeaker(withName name: String, completion: @escaping (String) -> Void)
    {
        let speakersRef = self.databaseRef.child(DataService.kSpeakersKey)
        let query = speakersRef.queryOrdered(byChild: "fullName").queryEqual(toValue: name)
        query.observeSingleEvent(of: .value, with:
        { snapshot in
            if !snapshot.exists()
            {
                completion("This speaker doesn't exist")
            }
            else
            {
                completion("This speaker does exist")
            }
        })
    }
}

extension FIRDataSnapshot
{
    var json: JSON
    {
        return JSON(self.value!)
    }
}
