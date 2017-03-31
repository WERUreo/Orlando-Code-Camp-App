//
//  SessionEntryViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SessionEntryViewController: UIViewController
{
    enum PickerTag: Int
    {
        case speaker, cospeaker, track, timeslot
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var speakerTextField: UITextField!
    @IBOutlet weak var cospeakerTextField: UITextField!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var timeslotTextField: UITextField!

    var speakerPicker = UIPickerView()
    var cospeakerPicker = UIPickerView()
    var trackPicker = UIPickerView()
    var timeslotPicker = UIPickerView()
    var speakers = [Speaker]()
    var tracks = [Track]()
    var timeslots = [Timeslot]()

    var selectedSpeaker: Speaker?
    var selectedCospeaker: Speaker?
    var selectedTrack: Track?
    var selectedTimeslot: Timeslot?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.speakerPicker.tag = PickerTag.speaker.rawValue
        self.cospeakerPicker.tag = PickerTag.cospeaker.rawValue
        self.trackPicker.tag = PickerTag.track.rawValue
        self.timeslotPicker.tag = PickerTag.timeslot.rawValue

        self.speakerPicker.delegate = self
        self.speakerPicker.dataSource = self
        self.cospeakerPicker.delegate = self
        self.cospeakerPicker.dataSource = self
        self.trackPicker.delegate = self
        self.trackPicker.dataSource = self
        self.timeslotPicker.delegate = self
        self.timeslotPicker.dataSource = self

        // Do any additional setup after loading the view.
        self.getSpeakers()
        self.getTracks()
        self.getTimeslots()
    }

    private func getSpeakers()
    {
        DataService.shared.getAllSpeakers
        { speakers, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                if let speakerList = speakers
                {
                    self.speakers = speakerList.sorted { $0.fullName! < $1.fullName! }
                }

                DispatchQueue.main.async
                {
                    self.speakerTextField.inputView = self.speakerPicker
                    self.cospeakerTextField.inputView = self.cospeakerPicker
                }
            }
        }
    }

    private func getTracks()
    {
        DataService.shared.getAllTracks
        { tracks, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                if let trackList = tracks
                {
                    self.tracks = trackList
                }

                DispatchQueue.main.async
                {
                    self.trackTextField.inputView = self.trackPicker
                }
            }
        }
    }

    private func getTimeslots()
    {
        DataService.shared.getAllTimeslots
        { timeslots, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                if let timeslotList = timeslots
                {
                    self.timeslots = timeslotList
                }

                DispatchQueue.main.async
                {
                    self.timeslotTextField.inputView = self.timeslotPicker
                }
            }
        }
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let name = self.nameTextField.text
        let description = self.descriptionTextField.text
        let level = self.levelSegmentedControl.selectedSegmentIndex + 1
        let speaker = self.selectedSpeaker
        var cospeakers: [Speaker]?
        if let cospeaker = self.selectedCospeaker
        {
            if (cospeakers?.append(cospeaker)) == nil
            {
                cospeakers = [cospeaker]
            }
        }
        let track = self.selectedTrack
        let timeslot = self.selectedTimeslot

        let session = Session(name: name, description: description, level: level, speaker: speaker, cospeakers: cospeakers, track: track, timeslot: timeslot)
        DataService.shared.saveSession(session)
        {
            self.nameTextField.text = ""
            self.descriptionTextField.text = ""
            self.levelSegmentedControl.selectedSegmentIndex = 0
            self.speakerTextField.text = ""
            self.cospeakerTextField.text = ""
            self.trackTextField.text = ""
            self.timeslotTextField.text = ""

            self.selectedSpeaker = nil
            self.selectedCospeaker = nil
            self.selectedTrack = nil
            self.selectedTimeslot = nil
        }
    }
}

extension SessionEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView.tag
        {
            case PickerTag.speaker.rawValue, PickerTag.cospeaker.rawValue:
                return self.speakers.count
            case PickerTag.track.rawValue:
                return self.tracks.count
            case PickerTag.timeslot.rawValue:
                return self.timeslots.count
            default:
                return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag
        {
            case PickerTag.speaker.rawValue, PickerTag.cospeaker.rawValue:
                return self.speakers[row].fullName
            case PickerTag.track.rawValue:
                return self.tracks[row].name
            case PickerTag.timeslot.rawValue:
                return "\(self.timeslots[row].startTime!) - \(self.timeslots[row].endTime!)"
            default:
                return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch pickerView.tag
        {
            case PickerTag.speaker.rawValue:
                self.speakerTextField.text = self.speakers[row].fullName
                self.selectedSpeaker = self.speakers[row]
            case PickerTag.cospeaker.rawValue:
                self.cospeakerTextField.text = self.speakers[row].fullName
                self.selectedCospeaker = self.speakers[row]
            case PickerTag.track.rawValue:
                self.trackTextField.text = self.tracks[row].name
                self.selectedTrack = self.tracks[row]
            case PickerTag.timeslot.rawValue:
                self.timeslotTextField.text = "\(self.timeslots[row].startTime!) - \(self.timeslots[row].endTime!)"
                self.selectedTimeslot = self.timeslots[row]
            default:
                break
        }
    }
}
