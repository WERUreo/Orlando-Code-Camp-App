//
//  TrackEntryViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class TrackEntryViewController: UIViewController
{
    @IBOutlet weak var trackNameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let trackName = trackNameTextField.text
        let roomNumber = roomNumberTextField.text

        let track = Track(name: trackName, roomNumber: roomNumber, sessions: nil)
        DataService.shared.saveTrack(track)
        {
            trackNameTextField.text = ""
            roomNumberTextField.text = ""
        }
    }
}
