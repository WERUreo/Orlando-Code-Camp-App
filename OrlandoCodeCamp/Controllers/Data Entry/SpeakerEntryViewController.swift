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
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

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

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var speaker: Speaker?

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureView()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureView()
    {
        if let speaker = self.speaker
        {
            self.fullNameTextField.text = speaker.fullName
            self.companyTextField.text = speaker.company ?? ""
            self.titleTextField.text = speaker.title ?? ""
            self.bioTextField.text = speaker.bio ?? ""
            self.twitterTextField.text = speaker.twitter ?? ""
            self.websiteTextField.text = speaker.website ?? ""
            self.blogTextField.text = speaker.blog ?? ""
            self.avatarURLTextField.text = speaker.avatarURL
            self.mvpDetailsTextField.text = speaker.mvpDetails ?? ""
            self.authorDetailsTextField.text = speaker.authorDetails ?? ""
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - IBActions
    ////////////////////////////////////////////////////////////

    @IBAction func cancelTapped(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    ////////////////////////////////////////////////////////////

    @IBAction func submitTapped(_ sender: Any)
    {
        guard let fullName = self.fullNameTextField.text,
                  fullName != "" else
        {
            let alert = UIAlertController(title: "Name Required", message: "You must enter a name for this speaker", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }

        let company: String? = self.companyTextField.text != "" ? self.companyTextField.text : nil
        let title: String? = self.titleTextField.text != "" ? self.titleTextField.text : nil
        let bio: String? = self.bioTextField.text != "" ? self.bioTextField.text : nil
        let twitter: String? = self.twitterTextField.text != "" ? self.twitterTextField.text : nil
        let website: String? = self.websiteTextField.text != "" ? self.websiteTextField.text : nil
        let blog: String? = self.blogTextField.text != "" ? self.blogTextField.text : nil
        let avatarURL = self.avatarURLTextField.text!
        let mvpDetails: String? = self.mvpDetailsTextField.text != "" ? self.mvpDetailsTextField.text : nil
        let authorDetails: String? = self.authorDetailsTextField.text != "" ? self.authorDetailsTextField.text : nil

        DataService.shared.saveSpeaker(name: fullName, title: title, company: company, bio: bio, twitter: twitter, website: website, blog: blog, avatarURL: avatarURL, mvpDetails: mvpDetails, authorDetails: authorDetails)
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

            self.dismiss(animated: true, completion: nil)
        }
    }

    ////////////////////////////////////////////////////////////

    @IBAction func deleteTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this speaker?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "Yes", style: .destructive)
        { action in
            if let speaker = self.speaker
            {
                DataService.shared.deleteSpeaker(speaker.fullName, completion:
                {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
