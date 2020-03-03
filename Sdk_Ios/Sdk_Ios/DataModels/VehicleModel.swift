//
//  VehicleModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-16.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

public class VehicleModel: NSObject,Mappable,NSCoding {
    
    var model : String?
    var id: String?
    var make: String?
    var selected = false
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.model <- map["model"]
        self.id <- map["id"]
        self.make <- map["make"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.model =  aDecoder.decodeObject(forKey: "model") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.make = aDecoder.decodeObject(forKey: "make") as? String
        self.selected = aDecoder.decodeObject(forKey: "selected") as? Bool ?? false
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(model, forKey: "model")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(make, forKey: "make")
        aCoder.encode(selected, forKey: "selected")
    }
    
}
