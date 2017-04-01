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


    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Helper Functions
    ////////////////////////////////////////////////////////////

    func configureTableView()
    {
        self.tableView.register(ScheduleCell.self)

        self.tableView.estimatedRowHeight = 86
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITableViewDelegate, UITableViewDataSource
////////////////////////////////////////////////////////////

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
}
