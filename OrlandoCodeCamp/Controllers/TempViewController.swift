//
//  TempViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/3/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DataService.shared.updateAllSessions()
    }
}
