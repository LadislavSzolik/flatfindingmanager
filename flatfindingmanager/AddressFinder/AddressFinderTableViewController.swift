//
//  AddressFinderTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit
import MapKit

protocol SelectFlatAddressDelegate {
    func didSelect(address: FlatAddress)
}

class AddressFinderTableViewController: BaseTableViewController {
    
    var delegate: SelectFlatAddressDelegate?
    var completer = MKLocalSearchCompleter()
    var searchBar = UISearchBar()
    var resultSet = [FlatAddress]()
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        navigationItem.titleView = searchBar
        
        tableView.tableFooterView = UIView()
        
        completer.delegate = self
        completer.region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 47.37, longitude: 8.52), span: MKCoordinateSpan.init())
        completer.filterType = MKLocalSearchCompleter.FilterType.locationsOnly
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFlatAdress.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
        let flatAddress = filteredFlatAdress[indexPath.row]
        configureCell(cell, forFlatAddress: flatAddress )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let resultAddress = resultSet[indexPath.row]
        delegate?.didSelect(address: resultAddress)
        dismiss(animated: true, completion: nil)
    }


}

extension AddressFinderTableViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        let maxCount = 20
        var counter = 0
        resultSet = [FlatAddress]()
        for result in results {
            resultSet.append(FlatAddress(title: result.title, subTitle: result.subtitle))
            counter = counter + 1
            if maxCount < counter {
                break
            }
        }
        filteredFlatAdress = resultSet
        tableView.reloadData()
    }
}

extension AddressFinderTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completer.queryFragment = searchBar.text!
    }
    

    
}
