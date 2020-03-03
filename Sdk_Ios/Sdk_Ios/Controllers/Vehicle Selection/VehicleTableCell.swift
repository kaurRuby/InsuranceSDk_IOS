//
//  VehicleTableCell.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-18.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

class VehicleTableCell: UITableViewCell {
    
    @IBOutlet weak var img_radio: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
