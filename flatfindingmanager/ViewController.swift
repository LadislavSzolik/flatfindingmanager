//
//  ViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 10.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var completer = MKLocalSearchCompleter()
    
    private var resultsTableController: AddressResultsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableController = AddressResultsTableViewController()
        resultsTableController.tableView.delegate = self
        
        completer.delegate = self
        completer.region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 47.37, longitude: 8.52), span: MKCoordinateSpan.init())
        completer.filterType = MKLocalSearchCompleter.FilterType.locationsOnly
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
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
        
        
        resultsTableController.filteredFlatAdress = resultSet
        resultsTableController.tableView.reloadData()
        
    }

 
    
    
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         completer.queryFragment = searchBar.text!
    }
    
}




