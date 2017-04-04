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
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var sessions = [Session]()

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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        super.prepare(for: segue, sender: sender)
//
//        if let vc = segue.destination as? ScheduleEditViewController,
//           segue.identifier == "EditSession",
//           let session = sender as? Session
//        {
//            vc.session = session
//        }
//    }

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
            if let sessionList = sessions
            {
                self.sessions = sessionList.sorted { $0.name < $1.name }
                self.tableView.reloadData()
            }
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITableViewDelegate, UITableViewDataSource
////////////////////////////////////////////////////////////

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.sessions.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleCell
        cell.configure(with: self.sessions[indexPath.row])
        return cell
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let session = self.sessions[indexPath.row]
//        performSegue(withIdentifier: "EditSession", sender: session)
    }
}

