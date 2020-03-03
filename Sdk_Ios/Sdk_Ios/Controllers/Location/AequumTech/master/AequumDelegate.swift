//
//  AequumDelegate.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import CoreLocation

public protocol AequumDelegate {
    
    func gotTimedLocation(_ location: AEMotionEntity)
    func gotDerivedLocation(_ location: AEMotionEntity)
    func gotAcceleration(timestamp: Date, acceleration: Double)
}
