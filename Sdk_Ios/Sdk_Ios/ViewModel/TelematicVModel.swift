//
//  TelematicVModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-19.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

class TelematicVModel: BaseVModel {

    //MARK: Variables
       var info : UserInfo?
       var paramDic: [String:AnyObject]?
       
       var callPostTelematicsInfoService : Bool?{
           didSet{
               callPostTelematicsInfoApi(user:info)
           }
       }
       
       //MARK:- Verify auth code Api Call
    
       private func callPostTelematicsInfoApi(user:UserInfo?){
           self.isLoading = true
           var header = ["Content-Type":"application/json"]
           header["Device"] = user?.device ?? ""
           header["Authorization"] = "ATBearer " + (user?.token ?? "")
           header["perform"] = "EVENT"
           
           WebServices.callPostApi(urlStr: ApiServiceName.telematicsServerUrl
               + ApiServiceName.telematicsUpdateUrl, params: paramDic, headers: header, oncompletion: { (status, message, response) in
                   self.isLoading = false
                   if status ?? false{
                       if let payload  = response?["payload"] as? [String:AnyObject]{
                           //let policyInfo = Mapper<PolicyModel>().map(JSONObject: payload)
                       }
                       self.responseRecieved?()
                   }else{
                       self.alertMessage = message
                   }
           })
       }
}
