//
//  ConstantValues.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-17.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

//MARK:- api services urls

struct ApiServiceName{
    static let policyServerUrl = "https://api-policy.aequumtech.com/"
    static let policyUserUrl = "api/v1.0.1/users/user"
    static let policyInfoUrl = "api/v1.0.1/policy/info"
    static let currentBalanceInfoUrl = "api/v1.0.1/users/landing"
    
    static let telematicsServerUrl = "https://api-producer.aequumtech.com/"
    static let telematicsUpdateUrl = "api/v1.0.1/sqspayloads"
    static let telematicsRateHistoryUrl = "api/v1.0.1/users/user/ratehistory2"
    static let telematicsTransactionUrl = "api/v1.0.1/users/user/transactions2"
    
    static let telematcisWebUrl = "https://api-tracker.aequumtech.com/"
    static let telematicsDashboardUrl = "api/v1.0.1/users/user/dashboard"
}

//MARK:- UserDefaults keys

struct UserDefaultKeys{
    static let isDriver = "isDriver"
    static let user = "user"
    static let userDic = "userDic"
    static let deviceToken = "deviceToken"
    static let deviceId = "deviceId"
    static let policyInfo = "policyInfo"
    static let selectedCarID = "selectedCarID"
    static let selectedCarName = "selectedCarName"
    static let selectedUDID = "selectedUDID"
    static let tripStarted = "tripStarted"
    static let tripEnded = "tripEnded"
    static let tripTime = "tripTime"
    static let previousLocation = "previousLocation"
    static let tripID = "tripID"
    static let firstTimeAfterSignup = "firstTimeAfterSignup"
    static let callLocation = "callLocation"
}
