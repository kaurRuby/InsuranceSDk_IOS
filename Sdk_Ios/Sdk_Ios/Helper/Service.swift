//
//  Service.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-13.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit

public class Service {

    public static func getMainVC(user:[String:AnyObject]) -> UIViewController{
        let vc =  VehicleSelection_VC(nibName: "VehicleSelection_VC", bundle: Bundle(for:  VehicleSelection_VC.self))
        vc.dic = user
        return vc
    }
    
    public static func getTelematicsVC(user:[String:AnyObject]) -> UIViewController{
        if let vc = UIStoryboard.init(name: "Telematics", bundle: Bundle(for: Telematics_ScrollVC.self)).instantiateViewController(identifier: "Telematics_ScrollVC") as? Telematics_ScrollVC{
            vc.dic = user
            return vc
        }
        return UIViewController()
        
    }
    
}
