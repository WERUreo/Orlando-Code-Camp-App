//
//  SpeakerCell.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/2/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit
import Alamofire

class SpeakerCell: UITableViewCell
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var titleCompanyLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var speakerImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    private var request: Request?

    ////////////////////////////////////////////////////////////
    // MARK: - Lifecycle
    ////////////////////////////////////////////////////////////

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.speakerImageView.layer.cornerRadius = self.speakerImageView.frame.width / 2.0
        self.speakerImageView.clipsToBounds = true
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Configuration
    ////////////////////////////////////////////////////////////

    func configure(with speaker: Speaker)
    {
        self.speakerNameLabel.text = speaker.fullName
        if let title = speaker.title
        {
            if let company = speaker.company
            {
                self.titleCompanyLabel.text = "\(title), \(company)"
            }
            else
            {
                self.titleCompanyLabel.text = "\(title)"
            }
        }
        else if let company = speaker.company
        {
            self.titleCompanyLabel.text = "\(company)"
        }
        else
        {
            self.titleCompanyLabel.isHidden = true
        }
        if let twitter = speaker.twitter
        {
            self.twitterLabel.text = twitter
        }
        else
        {
            self.twitterLabel.isHidden = true
        }

        self.configureImage(from: speaker.avatarURL)
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
        self.speakerImageView?.image = UIImage(named: "default_user")
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
            self.speakerImageView.image = image
        }
    }
}
