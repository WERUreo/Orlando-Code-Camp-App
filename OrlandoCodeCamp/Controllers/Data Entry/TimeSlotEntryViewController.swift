//
//  TimeSlotEntryViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class TimeSlotEntryViewController: UIViewController
{
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let startTime = startTimeTextField.text
        let endTime = endTimeTextField.text

        let timeslot = Timeslot(time: startTime!, rank: Int(endTime!)!, sessions: nil)
        DataService.shared.saveTimeSlot(timeslot)
        {
            startTimeTextField.text = ""
            endTimeTextField.text = ""
        }
    }
}
