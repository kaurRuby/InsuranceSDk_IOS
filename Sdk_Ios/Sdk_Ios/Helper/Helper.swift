//
//  Helper.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-16.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

public class Helper: NSObject {
    
    public static func getUser() -> UserInfo?{
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.user) as? Data{
            if let user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UserInfo{
                return user
            }
        }
        return nil
    }
    
    public static func getPolicyInfo(){
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.policyInfo) as? Data{
            if let policyInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? PolicyModel{
                
            }
        }
    }
    
    public static func saveUserInfo(user:UserInfo){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.user)
    }
    
    public static func savePolicyInfo(policy:PolicyModel){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: policy)
        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.policyInfo)
    }
    
}
