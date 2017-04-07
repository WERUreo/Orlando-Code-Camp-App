//
//  SessionDetailViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/4/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit
import Alamofire

class SessionDetailViewController: UIViewController
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerTitleCompanyLabel: UILabel!
    @IBOutlet weak var speakerTwitterLabel: UILabel!
    @IBOutlet weak var speakerAvatarImageView: UIImageView!
    @IBOutlet weak var sessionDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var session: Session!
    var request: Request?

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.speakerAvatarImageView.layer.cornerRadius = self.speakerAvatarImageView.frame.width / 2.0
        self.speakerAvatarImageView.clipsToBounds = true
        self.configure()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configure()
    {
        self.sessionNameLabel.text = self.session.name
        self.sessionDescriptionLabel.text = self.session.description

        if let speaker = self.session.speaker
        {
            self.speakerNameLabel.text = speaker.name

            if let title = speaker.title
            {
                if let company = speaker.company
                {
                    self.speakerTitleCompanyLabel.text = "\(title), \(company)"
                }
                else
                {
                    self.speakerTitleCompanyLabel.text = "\(title)"
                }
            }
            else if let company = speaker.company
            {
                self.speakerTitleCompanyLabel.text = "\(company)"
            }
            else
            {
                self.speakerTitleCompanyLabel.isHidden = true
            }

            self.speakerTwitterLabel.text = speaker.twitter
            self.configureImage(from: speaker.avatarURL)
        }
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