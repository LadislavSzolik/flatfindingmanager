//
//  InterestedTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

protocol SelectInterestedOptionDelegate {
    func didSelect(option: InterestedStatus)
}
class InterestedTableViewController: UITableViewController {

    var delegate: SelectInterestedOptionDelegate?
    var selectedOption:InterestedStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InterestedStatus.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        let option = InterestedStatus.all[indexPath.row]
        cell.textLabel?.text = option.title
        
        if option == selectedOption {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedOption = InterestedStatus.all[indexPath.row]
        delegate?.didSelect(option: selectedOption!)
        tableView.reloadData()
        
    }

    

}
