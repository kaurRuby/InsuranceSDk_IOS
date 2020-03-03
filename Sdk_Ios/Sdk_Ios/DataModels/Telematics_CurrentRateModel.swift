//
//  Telematics_CurrentRateModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2020-01-17.
//  Copyright © 2020 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_CurrentRateModel: NSObject,Mappable, NSCoding {
    
    var base : Int?
    var currentBalance: Double?
    var currentRate: Double?
    
    required public init?(map: Map){
    }
    
    public func mapping(map: Map){
        self.base <- map["base"]
        self.currentBalance <- map["currentBalance"]
        self.currentRate <- map["currentRate"]
    }
    
    
    required public init(coder aDecoder: NSCoder) {
        self.base =  aDecoder.decodeObject(forKey: "base") as? Int
        self.currentBalance = aDecoder.decodeObject(forKey: "currentBalance") as? Double
        self.currentRate = aDecoder.decodeObject(forKey: "currentRate") as? Double
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(base, forKey: "base")
        aCoder.encode(currentBalance, forKey: "currentBalance")
        aCoder.encode(currentRate, forKey: "currentRate")
    }
    
}


