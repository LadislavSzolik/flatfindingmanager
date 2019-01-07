//
//  AddFlatTableViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit
import CoreLocation
class AddFlatTableViewController: UITableViewController {
    
    var flat: Flat?

    @IBOutlet weak var visitDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var interestedText: UILabel!
    @IBOutlet weak var flatAddressText: UILabel!
    @IBOutlet weak var applicationStatusText: UILabel!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var monthlyRentInput: UITextField!
    
    
    var interestedOption: InterestedStatus?
    var flatAddress: FlatAddress?
    var applicationStatus: ApplicationStatus?
    
    var isVisitRequired: Bool = false
    var isVisitDateShown:Bool = false {
        didSet {
            visitDatePicker.isHidden = !isVisitDateShown
        }
    }
    var isOpenMapAllowed: Bool = false
    @IBOutlet weak var visitRequiredSwitch: UISwitch!
    var isFlatSaved: Bool = false
    
    var flatImages = [UIImage]()
    
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
    
    
    let sectionFlatAddress:Int = 0
    let sectionImages:Int = 1
    let sectionVisitDate: Int = 2
    let sectionDidYouApply: Int = 5
    let sectionComments: Int = 6
    let sectionDelete: Int = 7
    
    let visitDatePickerCellIndexPath = IndexPath(row: 2, section: 2)
    let showMapsButtonIndexPath = IndexPath(row: 1, section: 0)
    
    var isUserInterested: Bool = false
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    
        if let flat = flat {
            
            flatAddress = flat.address
            visitDatePicker.date = flat.visitDate ?? midnightToday
            interestedOption = flat.interested
            applicationStatus = flat.applied
            
            isFlatSaved = true
            isOpenMapAllowed = true
            isVisitRequired = flat.isVisitRequired
            visitRequiredSwitch.isOn = isVisitRequired
            flatImages = flat.flatImages
            
            monthlyRentInput.text = "\(flat.monthlyRent)"
            
            commentText.text = flat.comments
            
            updateFlatAddress()
            updateInterestedOption()
            updateApplicationStatus()
        } else {
            visitDatePicker.minimumDate = midnightToday
            visitDatePicker.date = midnightToday
            
            flatImages = [UIImage]()
            
            interestedOption = InterestedStatus.all[0]
            applicationStatus = ApplicationStatus.all[0]
        }
        
        updateDate()
       
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if commentText.isFirstResponder {
            commentText.resignFirstResponder()
        }
        
        if monthlyRentInput.isFirstResponder {
            monthlyRentInput.resignFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case sectionFlatAddress: return 2
        case sectionVisitDate: return 3
        case sectionDidYouApply:
            if isUserInterested {
                return 1
            } else {
                return 0
                }
        case sectionDelete:
            if isFlatSaved {
                return 1
            } else {
                return 0
                }
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section, indexPath.row) {
            case (showMapsButtonIndexPath.section, showMapsButtonIndexPath.row):
                if isOpenMapAllowed {
                    return 44.0
                } else {
                    return 0.0
                }
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
            case (sectionImages,0):
                    return 130.0
            
            case (sectionComments,0):
                    return 88.0
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
            case (showMapsButtonIndexPath.section, showMapsButtonIndexPath.row) :
                openAddress()
            default:
                break
        }
    }
    
    func openAddress() {
        let geocoder = CLGeocoder()
        var locationString = "Zurich"
        var streetAndHouse = "Zurich"
        var toBeSearchedQuery = ""
        
        if let address = flatAddress {
            streetAndHouse = address.title
            locationString = address.title + "," + address.subTitle
        }
        
        if (UIApplication.shared.canOpenURL( URL(string:"https://www.google.com/maps/")! )) {
            let alert = UIAlertController(title: "Open in Map App", message: nil, preferredStyle: .actionSheet)
            
            let button1 = UIAlertAction(title: "Apple Maps", style: .default) { (UIAlertAction) in
                
                geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let location = placemarks?.first?.location {
                            toBeSearchedQuery = "?q=\(streetAndHouse)&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                            let urlString = "http://maps.apple.com/".appending(toBeSearchedQuery)
                            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            if let url = URL(string: encodedString!) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            }
            alert.addAction(button1)
            
            let button2 = UIAlertAction(title: "Google Maps", style: .default) { (UIAlertAction) in
                geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let location = placemarks?.first?.location {
                            toBeSearchedQuery = "?q=\(streetAndHouse)&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                            let urlString = "https://www.google.com/maps/".appending(toBeSearchedQuery)
                            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            if let url = URL(string: encodedString!) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                print("could not create URL")
                            }
                        }
                    }
                }
            }
            alert.addAction(button2)
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            present(alert, animated: true, completion: nil)
            
        } else {
            geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let location = placemarks?.first?.location {
                        toBeSearchedQuery = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                        let urlString = "http://maps.apple.com/".appending(toBeSearchedQuery)
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
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
        } else if segue.identifier == "showApplicationStatusSegue" {
            let controller = segue.destination as! ApplicationDetailTableViewController
            controller.selectedStatus = applicationStatus
            controller.delegate = self
        } else if (segue.identifier == "ShowPagesSegue") {
            let allPageController = segue.destination as! PageViewController
            if let indexPathsOfCollection = imagesCollectionView.indexPathsForSelectedItems {
                allPageController.currentIndexFromParent = indexPathsOfCollection[0].row
            }
            allPageController.images = flatImages
            
        } else if (segue.identifier == "saveUnwind") {
            
          
           
            
            if let address = flatAddress, let interested = interestedOption, let application = applicationStatus  {
                var visit = Date()
                
                if isVisitRequired {
                    visit = visitDatePicker.date
                } else {
                    visit = Date.init()
                }
                
                let monthlyRent = Double(monthlyRentInput.text ?? "0")
                
                
                flat = Flat(address: address, visitDate: visit, visitRequired: isVisitRequired, interested: interested, applied: application, flatImages: flatImages, comments: commentText.text, monthlyRent: monthlyRent ?? 0 )
            }
        }
    }
    
    @IBAction
    func unwindToFlatDetails(segue: UIStoryboardSegue) {
        if segue.identifier == "DeleteImageSegue" {
            let itemViewController = segue.source as! ItemViewController
            flatImages.remove(at: itemViewController.itemIndex)
            imagesCollectionView.reloadData()
        }
    }
    
}





// MARK: - set the address


extension AddFlatTableViewController: SelectFlatAddressDelegate {
    func didSelect(address: FlatAddress) {
        flatAddress = address
        updateFlatAddress()
    }
    
    func updateFlatAddress () {
        if let address = flatAddress {
            if(!address.subTitle.isEmpty) {
                flatAddressText.text = "\(address.title) \n\(address.subTitle)"
            } else {
                flatAddressText.text = "\(address.title)"
            }
            isOpenMapAllowed = true
        }else {
            isOpenMapAllowed = false
        }
    }
}


extension AddFlatTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flatImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ImageCollectionCell
        
        if indexPath.row == flatImages.count {
            cell.imageView.image = UIImage(named: "add-photo-image")!
        } else {
            cell.imageView.image = flatImages[indexPath.row]
        }
        
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == flatImages.count {
            showImagePicker()
        } else {
            performSegue(withIdentifier: "ShowPagesSegue", sender: self)
        }
    }
}


extension AddFlatTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //let compressedImageData = selectedImage.jpegData(compressionQuality: 0.5)
            //let compressedImageJpeg = UIImage.init(data: compressedImageData!)
            flatImages.append(selectedImage)
            imagesCollectionView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    func saveImage(img:UIImage, completion:(_ imgData:Data)->()) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                completion(Data)
            }
        }
    } */
    
    func showImagePicker() {
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image source", message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - set the interested status

extension AddFlatTableViewController: SelectInterestedOptionDelegate {
    func didSelect(option: InterestedStatus) {
        interestedOption = option
        updateInterestedOption()
    }
    
    func updateInterestedOption() {
        interestedText.text = interestedOption?.title
        if interestedOption?.id == 1 {
            isUserInterested = true
        } else {
            isUserInterested = false
        }
    }
}

// MARK: - set the application status

extension AddFlatTableViewController: SelectApplicationResponseDelegate {
    func didSelect(status: ApplicationStatus) {
        applicationStatus = status
        updateApplicationStatus()
    }
    
    func updateApplicationStatus() {
        applicationStatusText.text = applicationStatus!.title
    }
}


// MARK: - hide apply session

extension AddFlatTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sectionDidYouApply && !isUserInterested {
            return CGFloat.leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == sectionDidYouApply && !isUserInterested {
            return UIView(frame: CGRect.init())
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sectionDidYouApply && !isUserInterested {
            return CGFloat.leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == sectionDidYouApply && !isUserInterested {
            return UIView(frame: CGRect.init())
        } else {
            return nil
        }
    }
}
