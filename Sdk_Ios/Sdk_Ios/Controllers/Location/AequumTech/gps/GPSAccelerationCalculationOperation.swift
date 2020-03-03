//
//  GPSAccelerationCalculationOperation.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-27.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

class GPSAccelerationCalculationOperation: Operation {    
    override func main() {
        while(true) {
            sleep(10)
            print("gps acceleration")
        }
    }
}
