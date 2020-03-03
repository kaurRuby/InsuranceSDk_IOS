//
//  Utils.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-23.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation

class Utils {
    
    
    static func convertToDisplayableTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"//this your string date format
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }

}
