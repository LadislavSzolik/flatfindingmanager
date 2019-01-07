//
//  FlatCellTableViewCell.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 15.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class FlatCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var flatImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func udpate(with flat: Flat) {
        title?.text = flat.address.title
        subTitle?.text = flat.currentStatus()
        if flat.flatImages.count > 0 {
            flatImage.image = flat.flatImages[0]           
        }
        
    }

}
