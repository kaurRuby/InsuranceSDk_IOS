//
//  UserInfo.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-16.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

public class UserInfo: NSObject,Mappable, NSCoding {
    
    var id : String?
    var tenantid: String?
    var name: String?
    var lastName: String?
    var phone: String?
    var postalcode: String?
    var policy: String?
    var device: String?
    var id1 : String?
    var id2 : String?
    var token : String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
       
        self.id <- map["id"]
        self.tenantid <- map["tenantid"]
        self.name <- map["name"]
        self.lastName <- map["lastName"]
        self.phone <- map["phone"]
        self.postalcode <- map["postalcode"]
        self.policy <- map["policy"]
        self.device <- map["device"]
        self.id1 <- map["id1"]
        self.id2 <- map["id2"]
        self.token <- map["token"]
    }

    
    required public init(coder aDecoder: NSCoder) {
        self.id =  aDecoder.decodeObject(forKey: "id") as? String
        self.tenantid = aDecoder.decodeObject(forKey: "tenantid") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.postalcode = aDecoder.decodeObject(forKey: "postalcode") as? String
        self.policy = aDecoder.decodeObject(forKey: "policy") as? String
        self.device = aDecoder.decodeObject(forKey: "device") as? String
        self.id1 =  aDecoder.decodeObject(forKey: "id1") as? String
        self.id2 =  aDecoder.decodeObject(forKey: "id2") as? String
        self.token =  aDecoder.decodeObject(forKey: "token") as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(tenantid, forKey: "tenantid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(postalcode, forKey: "postalcode")
        aCoder.encode(policy, forKey: "policy")
        aCoder.encode(device, forKey: "device")
        aCoder.encode(id1, forKey: "id1")
        aCoder.encode(id2, forKey: "id2")
        aCoder.encode(token, forKey: "token")
    }
    
}


