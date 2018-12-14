//
//  ApplicationDetailTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 14.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

protocol SelectApplicationResponseDelegate {
    func didSelect(status: ApplicationStatus)
}
class ApplicationDetailTableViewController: UITableViewController {
    
    var delegate: SelectApplicationResponseDelegate?
    var selectedStatus: ApplicationStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApplicationStatus.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        let status = ApplicationStatus.all[indexPath.row]
        cell.textLabel?.text = status.title
        
        if status == selectedStatus {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedStatus = ApplicationStatus.all[indexPath.row]
        delegate?.didSelect(status: selectedStatus!)
        tableView.reloadData()
        
    }

}
