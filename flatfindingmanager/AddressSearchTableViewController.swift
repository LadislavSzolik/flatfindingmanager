//
//  AddressSearchTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 12.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit
import MapKit

class AddressSearchTableViewController: BaseTableViewController {
    
    private var searchController: UISearchController!
    private var resultsTableController: AddressResultsTableViewController!
    var completer = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableController = AddressResultsTableViewController()
        
        resultsTableController.tableView.delegate = self
        resultsTableController.tableView.tableFooterView = UIView()
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Enter address..."
        searchController.searchBar.delegate = self
        
        
        
        
        completer.delegate = self
        completer.region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 47.37, longitude: 8.52), span: MKCoordinateSpan.init())
        completer.filterType = MKLocalSearchCompleter.FilterType.locationsOnly

        tableView.tableFooterView = UIView()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //searchController.isActive = true
        //searchController.searchBar.becomeFirstResponder()
    }
  
    
}




// MARK: - TableViewDataSource

extension AddressSearchTableViewController {
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



// MARK: - UISearchBarDelegate

extension AddressSearchTableViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchControllerDelegate

extension AddressSearchTableViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { [unowned self] in
            //print("sall")
            //self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension AddressSearchTableViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       
        completer.queryFragment = searchController.searchBar.text!
    }
}


extension AddressSearchTableViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let results = completer.results
        let maxCount = 10
        var counter = 0
        var resultSet = [FlatAddress]()
        for result in results {
            
            resultSet.append(FlatAddress(title: result.title, subTitle: result.subtitle))
            
            counter = counter + 1
            if maxCount < counter {
                break
            }
        }
        
        if let resultsController = searchController.searchResultsController as? AddressResultsTableViewController {
            resultsController.filteredFlatAdress = resultSet
            resultsController.tableView.reloadData()
        }
        
        
    }
}
