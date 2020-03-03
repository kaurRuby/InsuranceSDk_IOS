//
//  RateHistory_VM.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class RateHistory_VM: BaseVModel {

    //MARK: Variables
     
      var info : UserInfo?
      var rateValue = RateHistory.defaultValue
      var resultArr = [Double]()
    
      var callGetRateHistoryInfoService : Bool?{
          didSet{
              callGetRateHistoryInfoApi(user:info)
          }
      }
      
      //MARK:- Verify auth code Api Call
      
      private func callGetRateHistoryInfoApi(user:UserInfo?){
          self.isLoading = true
          var header = ["Content-Type":"application/json"]
          header["Device"] = user?.device ?? ""
          header["Authorization"] = "ATBearer " + (user?.token ?? "")
          header["perform"] = "EDGE"
          header["id"] = user?.id2 ?? ""  ///id2
          header["policy"] = user?.policy ?? ""
          header["tp"] = "\(rateValue)"
         
          WebServices.callGetApi(urlStr: ApiServiceName.policyServerUrl
              + ApiServiceName.telematicsRateHistoryUrl, params: nil, headers: header, oncompletion: { (status, message, response) in
                  self.isLoading = false
                  if status ?? false{
                      if let payload  = response?["payload"] as? [Double]{
                        self.resultArr = payload
                      }
                      self.responseRecieved?()
                  }else{
                      self.alertMessage = message
                  }
          })
          
      }
}
