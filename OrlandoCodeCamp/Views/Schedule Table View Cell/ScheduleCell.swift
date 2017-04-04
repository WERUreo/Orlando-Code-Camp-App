//
//  ScheduleCell.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/31/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleCell: UITableViewCell
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var timeLocationLabel: UILabel!
    @IBOutlet weak var speakerAvatarImageView: UIImageView!
    @IBOutlet weak var trackColorView: UIView!
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
        self.speakerAvatarImageView.layer.cornerRadius = self.speakerAvatarImageView.frame.width / 2.0
        self.speakerAvatarImageView.clipsToBounds = true
    }

    ////////////////////////////////////////////////////////////

    func configure(with session: Session)
    {
        self.sessionNameLabel.text = session.name
        self.speakerNameLabel.text = session.speaker.name
        self.configureImage(from: session.speaker.avatarURL)
        self.timeLocationLabel.text = "\(session.timeslot) (Room \(session.track.roomNumber))"
//        if let speaker = session.speaker
//        {
//            self.speakerNameLabel.text = speaker.name
//            self.configureImage(from: speaker.avatarURL)
//        }
//        else
//        {
//            self.speakerNameLabel.text = ""
//            self.speakerAvatarImageView.image = nil
//        }
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
