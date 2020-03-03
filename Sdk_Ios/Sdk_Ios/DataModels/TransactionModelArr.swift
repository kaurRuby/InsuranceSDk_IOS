//
//  TransactionModelArr.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionModelArr: NSObject,Mappable,NSCoding {
    
    var payload : [TransactionModel]?
   
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.payload <- map["payload"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.payload =  aDecoder.decodeObject(forKey: "payload") as? [TransactionModel]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(payload, forKey: "payload")
    }
    
}
