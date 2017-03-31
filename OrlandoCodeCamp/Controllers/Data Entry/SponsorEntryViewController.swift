//
//  SponsorEntryViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SponsorEntryViewController: UIViewController
{
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var sponsorLevelTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var avatarURLTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let companyName = companyNameTextField.text
        let sponsorLevel = sponsorLevelTextField.text
        let bio = bioTextField.text
        let twitter = twitterTextField.text
        let website = webSiteTextField.text
        let avatarURL = avatarURLTextField.text

        let sponsor = Sponsor(companyName: companyName, sponsorLevel: sponsorLevel, bio: bio, twitter: twitter, website: website, avatarURL: avatarURL)
        DataService.shared.saveSponsor(sponsor)
        {
            companyNameTextField.text = ""
            sponsorLevelTextField.text = ""
            bioTextField.text = ""
            twitterTextField.text = ""
            webSiteTextField.text = ""
            avatarURLTextField.text = ""
        }
    }
}
