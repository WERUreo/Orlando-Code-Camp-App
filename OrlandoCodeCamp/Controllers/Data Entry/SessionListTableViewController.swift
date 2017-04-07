//
//  SessionListTableViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 4/5/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class SessionListTableViewController: UITableViewController
{
    struct ScheduleSection
    {
        var title: String
        var sessions: [Session]
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var sessions = [Session]()
    var timeslots = [Timeslot]()
    var scheduleSections = [ScheduleSection]()

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
        self.tableView.register(ScheduleCell.self)
        self.tableView.estimatedRowHeight = 86
        self.tableView.rowHeight = UITableViewAutomaticDimension

        DataService.shared.getAllSessions
        { sessions, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let sessionList = sessions
            {
                self.sessions = sessionList.sorted { $0.timeslot.rank < $1.timeslot.rank }
                DataService.shared.getAllTimeslots(completion:
                { timeslots, error in
                    if let error = error
                    {
                        print(error.localizedDescription)
                    }
                    else if let timeslotList = timeslots
                    {
                        self.timeslots = timeslotList.sorted { $0.rank < $1.rank }
                        for time in self.timeslots
                        {
                            self.scheduleSections.append(ScheduleSection(title: time.time, sessions: self.sessions.filter { $0.timeslot.rank == time.rank }))
                            DispatchQueue.main.async { self.tableView.reloadData() }
                        }
                    }
                })
            }
        }
    }
    
    ////////////////////////////////////////////////////////////
    // MARK: - UITableViewSource
    ////////////////////////////////////////////////////////////

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.scheduleSections.count
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.scheduleSections[section].title
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.scheduleSections[section].sessions.count
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleCell
        cell.configure(with: self.scheduleSections[indexPath.section].sessions[indexPath.row])
        return cell
    }

    ////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let session = self.scheduleSections[indexPath.section].sessions[indexPath.row]
        performSegue(withIdentifier: "EditSession", sender: session)
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? SessionEntryViewController,
           segue.identifier == "EditSession",
           let session = sender as? Session
        {
            vc.session = session
        }
    }
}
