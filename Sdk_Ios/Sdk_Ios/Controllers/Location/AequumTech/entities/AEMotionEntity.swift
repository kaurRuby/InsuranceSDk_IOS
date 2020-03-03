//
//  AEMotionEntity.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-26.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

public class AEMotionEntity: NSObject, NSCoding {
    
    var speed: Double!
    var latitude: Double!
    var longitude: Double!
    var timestamp: Date!
    var acceleration: Double!
    var altitude : Double!
    
    required public override init() {
           
       }
    
    required public init(coder aDecoder: NSCoder) {
           self.speed =  aDecoder.decodeObject(forKey: "speed") as? Double
           self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
           self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
           self.timestamp = aDecoder.decodeObject(forKey: "timestamp") as? Date
           self.acceleration = aDecoder.decodeObject(forKey: "acceleration") as? Double
           self.altitude = aDecoder.decodeObject(forKey: "altitude") as? Double
       }

       public func encode(with aCoder: NSCoder) {
           aCoder.encode(speed, forKey: "speed")
           aCoder.encode(latitude, forKey: "latitude")
           aCoder.encode(longitude, forKey: "longitude")
           aCoder.encode(timestamp, forKey: "timestamp")
           aCoder.encode(acceleration, forKey: "acceleration")
           aCoder.encode(altitude, forKey: "altitude")
       }

}
