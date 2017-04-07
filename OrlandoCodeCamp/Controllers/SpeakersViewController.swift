//
//  SpeakersViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/2/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SpeakersViewController: UIViewController
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var speakers = [Speaker]()

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Life Cycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureTableView()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureTableView()
    {
        self.tableView.register(SpeakerCell.self)
        self.tableView.estimatedRowHeight = 86
        self.tableView.rowHeight = UITableViewAutomaticDimension

        DataService.shared.getAllSpeakers
        { speakers, error in
            if let speakerList = speakers
            {
                self.speakers = speakerList.sorted { $0.fullName < $1.fullName }
                self.tableView.reloadData()
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? SpeakerDetailViewController,
           segue.identifier == "SpeakerDetail",
           let speaker = sender as? Speaker
        {
            vc.speaker = speaker
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITableViewDelegate, UITableViewDataSource
////////////////////////////////////////////////////////////

extension SpeakersViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.speakers.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SpeakerCell
        cell.configure(with: self.speakers[indexPath.row])
        return cell
    }

    ////////////////////////////////////////////////////////////


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let speaker = self.speakers[indexPath.row]
        performSegue(withIdentifier: "SpeakerDetail", sender: speaker)
    }
}
