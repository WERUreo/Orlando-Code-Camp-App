//
//  SpeakerListTableViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/5/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SpeakerListTableViewController: UITableViewController
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var speakers = [Speaker]()

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }

    ////////////////////////////////////////////////////////////

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.configureTableView()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureTableView()
    {
        self.tableView.register(SpeakerCell.self)
        self.tableView.estimatedRowHeight = 95
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        DataService.shared.getAllSpeakers
        { speakers, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let speakerList = speakers
            {
                self.speakers = speakerList.sorted { $0.fullName < $1.fullName }
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    ////////////////////////////////////////////////////////////

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.speakers.count
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SpeakerCell
        cell.configure(with: self.speakers[indexPath.row])
        return cell
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let speaker = self.speakers[indexPath.row]
        performSegue(withIdentifier: "EditSpeaker", sender: speaker)
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? SpeakerEntryViewController,
           segue.identifier == "EditSpeaker",
           let speaker = sender as? Speaker
        {
            vc.speaker = speaker
        }
    }
}
