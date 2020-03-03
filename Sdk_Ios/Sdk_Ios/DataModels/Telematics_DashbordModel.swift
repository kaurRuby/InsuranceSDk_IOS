//
//  Telematics_DashbordModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-31.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_DashbordModel: NSObject,Mappable, NSCoding {
    
    var normal : Int?
    var drivenKm: Int?
    var drivenSec: Int?
    var parkedSec: Int?
    var night: Int?
    var overall: Int?
    var aggressive: Int?
    var distracted: Int?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map){
        self.normal <- map["normal"]
        self.drivenKm <- map["drivenKm"]
        self.drivenSec <- map["drivenSec"]
        self.parkedSec <- map["parkedSec"]
        self.night <- map["night"]
        self.overall <- map["overall"]
        self.aggressive <- map["aggressive"]
        self.distracted <- map["distracted"]
    }
    
    
    required public init(coder aDecoder: NSCoder) {
        self.normal =  aDecoder.decodeObject(forKey: "normal") as? Int
        self.drivenKm = aDecoder.decodeObject(forKey: "drivenKm") as? Int
        self.drivenSec = aDecoder.decodeObject(forKey: "drivenSec") as? Int
        self.parkedSec = aDecoder.decodeObject(forKey: "parkedSec") as? Int
        self.night = aDecoder.decodeObject(forKey: "night") as? Int
        self.overall = aDecoder.decodeObject(forKey: "overall") as? Int
        self.aggressive = aDecoder.decodeObject(forKey: "aggressive") as? Int
        self.distracted = aDecoder.decodeObject(forKey: "distracted") as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(normal, forKey: "normal")
        aCoder.encode(drivenKm, forKey: "drivenKm")
        aCoder.encode(drivenSec, forKey: "drivenSec")
        aCoder.encode(parkedSec, forKey: "parkedSec")
        aCoder.encode(night, forKey: "night")
        aCoder.encode(overall, forKey: "overall")
        aCoder.encode(aggressive, forKey: "aggressive")
        aCoder.encode(distracted, forKey: "distracted")
    }
    
}


