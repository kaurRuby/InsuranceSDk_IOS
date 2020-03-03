//
//  AccelerationTableViewCell.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-21.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

class AccelerationTableViewCell: UITableViewCell {

    @IBOutlet var Mlabel: UILabel!
    @IBOutlet var Alabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var delegate: Slide0Protocol!
    
    @IBOutlet var accelArrayCount: UILabel!
    @IBOutlet var clearButton: UIButton!
    
    @IBAction func clearDebut(_ sender: Any) {
        delegate.clearAccelerometer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
