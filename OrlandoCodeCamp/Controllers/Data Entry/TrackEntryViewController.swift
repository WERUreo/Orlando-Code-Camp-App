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

    var track: Track?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureView()
    }

    func configureView()
    {
        if let track = self.track
        {
            self.trackNameTextField.text = track.name
            self.roomNumberTextField.text = track.roomNumber
        }
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let trackName = self.trackNameTextField.text!
        let roomNumber = self.roomNumberTextField.text!

        DataService.shared.saveTrack(name: trackName, roomNumber: roomNumber)
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
