//
//  PolicyVModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-17.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class PolicyVModel: BaseVModel{
    
    //MARK: Variables
    var policyStr = ""
    var emailStr = ""
    var info : UserInfo?
    var policyModel: PolicyModel?
    
    var callGetPolicyInfoService : Bool?{
        didSet{
            callGetPolicyInfoApi(user:info)
        }
    }
    
    //MARK:- Verify auth code Api Call
    
    private func callGetPolicyInfoApi(user:UserInfo?){
        self.isLoading = true
        var header = ["Content-Type":"application/json"]
        header["Device"] = user?.device ?? ""
        header["Authorization"] = "ATBearer " + (user?.token ?? "")
        header["id"] = user?.policy ?? ""
        header["id1"] = user?.phone ?? ""
        header["id2"] = user?.id ?? ""
        header["perform"] = "EDGE"
        
        WebServices.callGetApi(urlStr: ApiServiceName.policyServerUrl
            + ApiServiceName.policyInfoUrl, params: nil, headers: header, oncompletion: { (status, message, response) in
                self.isLoading = false
                if status ?? false{
                    if let payload  = response?["payload"] as? [String:AnyObject]{
                        let policyInfo = Mapper<PolicyModel>().map(JSONObject: payload)
                        self.policyModel = policyInfo
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: policyInfo)
                        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.policyInfo)
                    }
                    self.responseRecieved?()
                }else{
                    self.alertMessage = message
                }
        })
    }
}
