//
//  SpeakerEntryViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/29/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SpeakerEntryViewController: UIViewController
{
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var blogTextField: UITextField!
    @IBOutlet weak var avatarURLTextField: UITextField!
    @IBOutlet weak var mvpDetailsTextField: UITextField!
    @IBOutlet weak var authorDetailsTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitTapped(_ sender: Any)
    {
        let fullName = fullNameTextField.text
        let company = companyTextField.text
        let title = titleTextField.text
        let bio = bioTextField.text
        let twitter = twitterTextField.text
        let website = websiteTextField.text
        let blog = blogTextField.text
        let avatarURL = avatarURLTextField.text
        let mvpDetails = mvpDetailsTextField.text
        let authorDetails = authorDetailsTextField.text

        let speaker = Speaker(fullName: fullName, company: company, title: title, bio: bio, twitter: twitter, website: website, blog: blog, avatarURL: avatarURL, mvpDetails: mvpDetails, authorDetails: authorDetails, sessions: nil)
        DataService.shared.saveSpeaker(speaker)
        {
            self.fullNameTextField.text = ""
            self.companyTextField.text = ""
            self.titleTextField.text = ""
            self.bioTextField.text = ""
            self.twitterTextField.text = ""
            self.websiteTextField.text = ""
            self.blogTextField.text = ""
            self.avatarURLTextField.text = ""
            self.mvpDetailsTextField.text = ""
            self.authorDetailsTextField.text = ""
        }
    }
}
