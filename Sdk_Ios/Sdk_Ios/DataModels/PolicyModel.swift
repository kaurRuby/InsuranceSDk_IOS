//
//  PolicyModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-16.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

public class PolicyModel: NSObject,Mappable, NSCoding{
    
    var tenantId : String?
    var policy: String?
    var vehicle: [VehicleModel]?
    var user: [UserInfo]?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.tenantId <- map["metadata.tenantId"]
        self.policy <- map["metadata.policy"]
        self.vehicle <- map["vehicles"]
        self.user <- map["users"]
    }
    
    required public init(coder aDecoder: NSCoder){
        self.tenantId = aDecoder.decodeObject(forKey: "tenantId") as? String
        self.policy = aDecoder.decodeObject(forKey: "policy") as? String
        self.vehicle = aDecoder.decodeObject(forKey: "vehicle") as? [VehicleModel]
        self.user = aDecoder.decodeObject(forKey: "user") as? [UserInfo]
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(tenantId, forKey: "tenantId")
        aCoder.encode(policy, forKey: "policy")
        aCoder.encode(vehicle, forKey: "vehicle")
        aCoder.encode(user, forKey: "user")
    }
    
}
