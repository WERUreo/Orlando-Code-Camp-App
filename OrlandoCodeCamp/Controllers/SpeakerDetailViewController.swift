//
//  SpeakerDetailViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/5/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit
import Alamofire

class SpeakerDetailViewController: UIViewController
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerTitleCompanyLabel: UILabel!
    @IBOutlet weak var speakerTwitterLabel: UILabel!
    @IBOutlet weak var speakerAvatarImageView: UIImageView!
    @IBOutlet weak var speakerBioLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var speaker: Speaker!
    var request: Request?

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.speakerAvatarImageView.layer.cornerRadius = self.speakerAvatarImageView.frame.width / 2.0
        self.speakerAvatarImageView.clipsToBounds = true        
        self.configureView()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureView()
    {
        self.speakerNameLabel.text = self.speaker.fullName

        if let title = self.speaker.title
        {
            if let company = self.speaker.company
            {
                self.speakerTitleCompanyLabel.text = "\(title), \(company)"
            }
            else
            {
                self.speakerTitleCompanyLabel.text = "\(title)"
            }
        }
        else if let company = self.speaker.company
        {
            self.speakerTitleCompanyLabel.text = "\(company)"
        }
        else
        {
            self.speakerTitleCompanyLabel.isHidden = true
        }
        if let twitter = self.speaker.twitter
        {
            self.speakerTwitterLabel.text = twitter
        }
        else
        {
            self.speakerTwitterLabel.isHidden = true
        }

        self.speakerBioLabel.text = self.speaker.bio ?? ""
        self.configureImage(from: self.speaker.avatarURL)

    }

    ////////////////////////////////////////////////////////////
    // MARK: - Private helper functions
    ////////////////////////////////////////////////////////////

    private func configureImage(from url: String)
    {
        reset()
        self.loadImage(from: url)
    }

    ////////////////////////////////////////////////////////////

    private func reset()
    {
        self.speakerAvatarImageView?.image = UIImage(named: "default_user")
        self.request?.cancel()
    }

    ////////////////////////////////////////////////////////////

    private func loadImage(from url: String)
    {
        self.activityIndicator.startAnimating()
        DataService.shared.getSpeakerImage(from: url)
        { image in
            self.populateCell(with: image)
        }
    }

    ////////////////////////////////////////////////////////////

    private func populateCell(with image: UIImage?)
    {
        self.activityIndicator.stopAnimating()
        if let image = image
        {
            self.speakerAvatarImageView.image = image
        }
    }
}
