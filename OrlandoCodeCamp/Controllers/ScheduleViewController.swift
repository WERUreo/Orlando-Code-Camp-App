//
//  ScheduleViewController.swift
//  OrlandoCodeCamp
//
//  Created by Keli'i Martin on 3/31/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController
{
    struct ScheduleSection
    {
        var title: String
        var sessions: [Session]
    }

    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureTableView()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? SessionDetailViewController,
           segue.identifier == "SessionDetail",
           let session = sender as? Session
        {
            vc.session = session
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureSections()
    {
        DataService.shared.getAllTimeslots
        { timeslots, error in
            if let timeslotList = timeslots
            {
                self.timeslots = timeslotList.sorted { $0.rank < $1.rank }
                self.tableView.reloadData()
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func configureTableView()
    {
        self.tableView.register(ScheduleCell.self)
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension

        DataService.shared.getAllSessions
        { sessions, error in
            if let sessionList = sessions
            {
                self.sessions = sessionList.sorted { $0.timeslot.rank < $1.timeslot.rank }
                DataService.shared.getAllTimeslots(completion:
                { timeslots, error in
                    if let timeslotList = timeslots
                    {
                        self.timeslots = timeslotList.sorted { $0.rank < $1.rank }
                        for time in self.timeslots
                        {
                            self.scheduleSections.append(ScheduleSection(title: time.time, sessions: self.sessions.filter { $0.timeslot.rank == time.rank }))

                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITableViewDelegate, UITableViewDataSource
////////////////////////////////////////////////////////////

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.scheduleSections.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.scheduleSections[section].title
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.scheduleSections[section].sessions.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleCell
        cell.configure(with: self.scheduleSections[indexPath.section].sessions[indexPath.row])
        return cell
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let session = self.scheduleSections[indexPath.section].sessions[indexPath.row]
        performSegue(withIdentifier: "SessionDetail", sender: session)
    }
}

