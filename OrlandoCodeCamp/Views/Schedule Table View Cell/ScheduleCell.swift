//
//  ScheduleCell.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/31/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

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
    

    ////////////////////////////////////////////////////////////
    // MARK: - Lifecycle
    ////////////////////////////////////////////////////////////

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    ////////////////////////////////////////////////////////////

    func configure(with session: Session)
    {
        
    }
}
