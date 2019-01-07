//
//  FlatsTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 15.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class FlatsTableViewController: UITableViewController {

    var flats: [Flat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if flats.count == 0 {
            flats = Flat.loadFromFile()
        }
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Flat.saveToFile(flats: self.flats)
        self.tableView.reloadData()
        
       
        DispatchQueue.global(qos: .background).async {
            Flat.saveToFile(flats: self.flats)
             /*
            DispatchQueue.main.async {
                self.tableView.reloadData()
            } */
        }
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return flats.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWithPic", for: indexPath) as! FlatCellTableViewCell

        let flat = flats[indexPath.row]
        cell.udpate(with: flat)
        
        cell.showsReorderControl = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedFlat = flats.remove(at: sourceIndexPath.row)
        flats.insert(movedFlat, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            flats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }


    @IBAction func unwindToFlatsTableView(segue: UIStoryboardSegue) {
        if segue.identifier == "saveUnwind" {
           
            let sourceController = segue.source as! AddFlatTableViewController
        
            
            
            if let flat = sourceController.flat {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    print("edited")
                    flats[selectedIndexPath.row] = flat
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    let newIndexPath = IndexPath(row: flats.count, section: 0)
                    flats.append(flat)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                
                
               
            }
        } else if segue.identifier == "deleteUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                flats.remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .fade)
                
            }
            
        }
       
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFlatSegue" {
            let indexPath = tableView.indexPathForSelectedRow!
            let flat = flats[indexPath.row]
            let navigationController = segue.destination as! UINavigationController
            let addFlatController = navigationController.topViewController as! AddFlatTableViewController
            addFlatController.flat = flat
        }
    }
    

}
