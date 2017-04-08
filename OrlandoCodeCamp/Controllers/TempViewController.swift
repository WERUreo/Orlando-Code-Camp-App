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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func searchTapped(_ sender: Any)
    {
        let searchText = self.searchTextField.text!
        DataService.shared.findSpeaker(withName: searchText)
        { result in
            self.resultsTextView.text = result
        }
    }
}
