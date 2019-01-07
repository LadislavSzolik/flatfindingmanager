//
//  ItemViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 19.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    var itemIndex: Int = 0
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        contentImageView.image = image
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
