//
//  TransactionCell.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var lbl_rate: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_car: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
