//
//  AddressResultsTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 12.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class AddressResultsTableViewController: BaseTableViewController {

    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFlatAdress.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
        let flatAddress = filteredFlatAdress[indexPath.row]
        configureCell(cell, forFlatAddress: flatAddress )
        
        return cell
    }

   

}
