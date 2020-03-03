//
//  WebService.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-17.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

typealias ServiceResponseReturn = (Bool?, String?, NSDictionary?) -> Void
typealias ServiceResponseString = (Bool?, String?) -> Void

class WebServices: NSObject {
    
    class func callPostApi(urlStr:String,params:[String:AnyObject]?,headers:[String:String]?, oncompletion:@escaping ServiceResponseReturn){
        
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                var success : Bool?
                var message = ""
                if let errorDic = json["error"] as? [String : Any]{
                    if let errorCode = errorDic["code"] as? String{
                        if errorCode == "0"{
                            if let successDic = json["success"] as? [String : Any]{
                                if let successCode = successDic["code"] as? String{
                                    if successCode == "0"{
                                        success = true
                                    }else{
                                        message = "There is some error. Please contact with admin."
                                        success = false
                                    }
                                }
                            }
                        }else{
                            message = "There is some error. Please contact with admin."
                            success = false
                        }
                    }
                }
                oncompletion(success,message,json as NSDictionary)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    
    class func callGetApi(urlStr:String,params:[String:AnyObject]?,headers:[String:String]?, oncompletion:@escaping ServiceResponseReturn){
        
        //create the url with NSURL
        let url = URL(string: urlStr)! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    var success : Bool?
                    var message = ""
                    if let errorDic = json["error"] as? [String : Any]{
                        if let errorCode = errorDic["code"] as? String{
                            if errorCode == "0"{
                                if let successDic = json["success"] as? [String : Any]{
                                    if let successCode = successDic["code"] as? String{
                                        if successCode == "0"{
                                            success = true
                                        }else{
                                            message = "There is some error. Please contact with admin."
                                            success = false
                                        }
                                    }
                                }
                            }else{
                                message = "There is some error. Please contact with admin."
                                success = false
                            }
                        }
                    }
                    oncompletion(success,message,json as NSDictionary)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
