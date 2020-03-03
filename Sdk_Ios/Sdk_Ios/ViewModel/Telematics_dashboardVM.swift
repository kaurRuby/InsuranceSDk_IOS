//
//  Telematics_dashboardVM.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-30.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_dashboardVM: BaseVModel {
    
    //MARK: Variables
    
    var info : UserInfo?
    var resultModel : Telematics_DashbordModel?
    var fromStr = ""
    var toStr = ""
    var callGetTransactionsDashboardService : Bool?{
        didSet{
            callGetTransactionsDashboardApi(user:info)
        }
    }
    
    //MARK:- Verify auth code Api Call
    
    private func callGetTransactionsDashboardApi(user:UserInfo?){
        self.isLoading = true
        var header = ["Content-Type":"application/json"]
        header["Device"] = user?.device ?? ""
        header["Authorization"] = "ATBearer " + (user?.token ?? "")
        header["perform"] = "EDGE"
        header["tenantId"] = "2"
        header["id"] = user?.id2 ?? ""  ///id2
        header["policy"] = user?.policy ?? ""
        header["periodY"] = "2019"
        header["periodM"] = "12"
        
        let url = ApiServiceName.telematcisWebUrl
        + ApiServiceName.telematicsDashboardUrl
        WebServices.callGetApi(urlStr: url, params: nil, headers: header, oncompletion: { (status, message, response) in
                self.isLoading = false
                if status ?? false{
                    if let payload = response?.value(forKey: "payload") as? [String:AnyObject]{
                        let info = Mapper<Telematics_DashbordModel>().map(JSONObject: payload)
                        self.resultModel = info
                    }
                    
                    self.responseRecieved?()
                }else{
                    self.alertMessage = message
                }
        })
    }
}

