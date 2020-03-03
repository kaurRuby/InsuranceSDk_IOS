//
//  TransactionModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionModel:NSObject,Mappable, NSCoding {
    
    var fromDate : String?
    var drivenKm: Int?
    var reason: String?
    var highestRate: Double?
    var cost: Int?
    var car: String?
  
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
       
        self.fromDate <- map["fromDate"]
        self.drivenKm <- map["tenantid"]
        self.reason <- map["name"]
        self.highestRate <- map["lastName"]
        self.cost <- map["cost"]
        self.car <- map["car"]
    
    }

    
    required public init(coder aDecoder: NSCoder) {
        self.fromDate =  aDecoder.decodeObject(forKey: "fromDate") as? String
        self.drivenKm = aDecoder.decodeObject(forKey: "drivenKm") as? Int
        self.reason = aDecoder.decodeObject(forKey: "reason") as? String
        self.highestRate = aDecoder.decodeObject(forKey: "highestRate") as? Double
        self.cost = aDecoder.decodeObject(forKey: "cost") as? Int
        self.car = aDecoder.decodeObject(forKey: "car") as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(fromDate, forKey: "fromDate")
        aCoder.encode(drivenKm, forKey: "drivenKm")
        aCoder.encode(reason, forKey: "reason")
        aCoder.encode(highestRate, forKey: "highestRate")
        aCoder.encode(car, forKey: "car")
    }
    
}


