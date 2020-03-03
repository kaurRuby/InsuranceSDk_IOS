//
//  Telematics_CurrentRateVM.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2020-01-17.
//  Copyright © 2020 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_CurrentRateVM: BaseVModel {
    
     //MARK: Variables
    var resultModel : Telematics_CurrentRateModel?
        var info : UserInfo?
        var callGetTransactionsCurrentRateService : Bool?{
            didSet{
                callGetTransactionsCurrentRateApi(user:info)
            }
        }
        
        //MARK:- Verify auth code Api Call
        
        private func callGetTransactionsCurrentRateApi(user:UserInfo?){
            self.isLoading = true
            var header = ["Content-Type":"application/json"]
            header["Device"] = user?.device ?? ""
            header["Authorization"] = "ATBearer " + (user?.token ?? "")
            header["perform"] = "EDGE"
            header["id"] = user?.id2 ?? ""  ///id2
            header["policy"] = user?.policy ?? ""
            
            let url = ApiServiceName.policyServerUrl
            + ApiServiceName.currentBalanceInfoUrl
            WebServices.callGetApi(urlStr: url, params: nil, headers: header, oncompletion: { (status, message, response) in
                    self.isLoading = false
                    if status ?? false{
                        if let payload = response?.value(forKey: "payload") as? [String:AnyObject]{
                            let info = Mapper<Telematics_CurrentRateModel>().map(JSONObject: payload)
                            self.resultModel = info
                        }
                        
                        self.responseRecieved?()
                    }else{
                        self.alertMessage = message
                    }
            })
        }
    }


