//
//  AddFlatTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class AddFlatTableViewController: UITableViewController {

    @IBOutlet weak var visitDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var interestedText: UILabel!
    @IBOutlet weak var flatAddressText: UILabel!
    
    var interestedOption: Interested?
    var flatAddress: FlatAddress?
    
    var isVisitDateShown:Bool = false {
        didSet {
            visitDatePicker.isHidden = !isVisitDateShown
        }
    }
    @IBOutlet weak var visitRequiredSwitch: UISwitch!
    
    var isVisitRequired: Bool = false
    
    
    @IBAction func visitReqiuredSwitchChanged(_ sender: Any) {
        isVisitRequired = visitRequiredSwitch.isOn
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateText.text = dateFormatter.string(from: visitDatePicker.date)
    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
       updateDate()
    }
    
    let visitDatePickerCellIndexPath = IndexPath(row: 2, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let midnightToday = Calendar.current.startOfDay(for: Date())
        visitDatePicker.minimumDate = midnightToday
        visitDatePicker.date = midnightToday
        
        updateDate()
        
        interestedOption = Interested.all[0]
    }
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section, indexPath.row) {
        case (visitDatePickerCellIndexPath.section, visitDatePickerCellIndexPath.row-1):
            if isVisitRequired {
                return 44.0
            } else {
                return 0.0
            }
            case (visitDatePickerCellIndexPath.section, visitDatePickerCellIndexPath.row):
                if isVisitDateShown && isVisitRequired {
                    return 162.0
                } else {
                    return 0.0
                }
            default:
                return 44.0
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch(indexPath.section, indexPath.row) {
            case (visitDatePickerCellIndexPath.section, visitDatePickerCellIndexPath.row-1):
                isVisitDateShown = !isVisitDateShown
                tableView.beginUpdates()
                tableView.endUpdates()
            default:
                break
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInterestedOptionsSegue" {
            let controller = segue.destination as! InterestedTableViewController
            controller.selectedOption = interestedOption
            controller.delegate = self
        } else if segue.identifier == "ShowFlatFinder" {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! AddressFinderTableViewController
            controller.delegate = self
        }
    }
}

extension AddFlatTableViewController: SelectInterestedOptionDelegate {
    func didSelect(option: Interested) {
        interestedOption = option
        updateInterestedOption()
    }
    
    func updateInterestedOption() {
        interestedText.text = interestedOption?.title
    }
}


extension AddFlatTableViewController: SelectFlatAddressDelegate {
    func didSelect(address: FlatAddress) {
        flatAddress = address
        updateFlatAddress()
    }
    
    func updateFlatAddress () {
        if let address = flatAddress {
            flatAddressText.text = "\(address.title) \n\(address.subTitle)"
        }
        
    }
    
    
}
