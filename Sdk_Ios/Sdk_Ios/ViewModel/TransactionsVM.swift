//
//  TransactionsVM.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionsVM: BaseVModel {

      //MARK: Variables
          
           var info : UserInfo?
           var resultArr = [TransactionModel]()
           var fromStr = ""
           var toStr = ""
           var callGetTransactionsService : Bool?{
               didSet{
                   callGetTransactionsApi(user:info)
               }
           }
           
           //MARK:- Verify auth code Api Call
           
           private func callGetTransactionsApi(user:UserInfo?){
               self.isLoading = true
               var header = ["Content-Type":"application/json"]
               header["Device"] = user?.device ?? ""
               header["Authorization"] = "ATBearer " + (user?.token ?? "")
               header["perform"] = "EDGE"
               header["id"] = user?.id2 ?? ""  ///id2
               header["policy"] = user?.policy ?? ""
               header["pg"] = "1"
               header["pp"] = "6"
               header["from"] = fromStr
               header["to"] = toStr
            
               WebServices.callGetApi(urlStr: ApiServiceName.policyServerUrl
                   + ApiServiceName.telematicsTransactionUrl, params: nil, headers: header, oncompletion: { (status, message, response) in
                       self.isLoading = false
                       if status ?? false{
                          
                        let info = Mapper<TransactionModelArr>().map(JSONObject: response as? [String:AnyObject])
                        self.resultArr = info?.payload ?? [TransactionModel]()
                        self.responseRecieved?()
                       }else{
                           self.alertMessage = message
                       }
               })
               
           }
     }
