//
//  TrackListTableViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/5/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class TrackListTableViewController: UITableViewController
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var tracks = [Track]()

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        DataService.shared.getAllTracks
        { tracks, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let trackList = tracks
            {
                self.tracks = trackList.sorted { $0.name < $1.name }
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
        return self.tracks.count
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        cell.textLabel?.text = self.tracks[indexPath.row].name
        return cell
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let track = self.tracks[indexPath.row]
        self.performSegue(withIdentifier: "EditTrack", sender: track)
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? TrackEntryViewController,
           segue.identifier == "EditTrack",
           let track = sender as? Track
        {
            vc.track = track
        }
    }
}

