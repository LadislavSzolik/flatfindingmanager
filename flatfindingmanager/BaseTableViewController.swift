//
//  BaseTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 12.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    var filteredFlatAdress = [FlatAddress] ()
    
    // MARK: - Constants
    static let tableViewCellIdentifier = "cellID"
    private static let nibName = "TableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
        
    }
    
    
    func configureCell(_ cell: UITableViewCell, forFlatAddress flatAddress: FlatAddress) {
        cell.textLabel?.text = flatAddress.title
        cell.detailTextLabel?.text = flatAddress.subTitle
    }
    

}
