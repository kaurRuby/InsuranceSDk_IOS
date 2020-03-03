//
//  BaseModel.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-17.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

class BaseVModel {
    
    //MARK:- Variables
    var responseMessage : String?
    
    //MARK:- Variables
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showEmptyMsg: Bool? {
        didSet {
            showEmptyMsgClausre?()
        }
    }
    var isEndRefresh : Bool? {
        didSet {
            endRefreshClausre?()
        }
    }
    var showNoInternetScreen : Bool? {
        didSet {
            showNoInternetView?(showNoInternetScreen ?? false)
        }
    }
    
    //MARK:- Clausers
    var endRefreshClausre:(()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadTableViewClosure: (()->())?
    var showEmptyMsgClausre: (()->())?
    var showNoInternetView: ((Bool)->())?
    var responseRecieved: (()->())?
    var readAllResponseRecieved: (()->())?
    
    var logout : (()->())?
    
    init() {
        
    }
}

