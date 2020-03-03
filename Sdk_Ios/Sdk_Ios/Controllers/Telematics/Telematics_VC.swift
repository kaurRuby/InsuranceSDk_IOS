//
//  Telematics_VC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-19.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper

class Telematics_VC: UIViewController{
    
    @IBOutlet weak var btn_end: UIButton!
    @IBOutlet weak var btn_start: UIButton!
    @IBOutlet weak var lbl_tripInfo: UILabel!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_speed: UILabel!
        
    var paramDic : [String:AnyObject]?
    var dicArr = [[String:AnyObject]]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbl_speed.isHidden = true
        lbl_location.isHidden = true
        btn_start.isHidden = true
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.tripStarted) == true{
            AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
                       print("the person is in their \(vehicle)")
            })
        }
    }
    
    
    @IBAction func click_more(_ sender: UIButton) {
        let bundle =  Bundle(for:  VehicleSelection_VC.self)
        let vc = UIStoryboard.init(name: "Telematics", bundle: bundle).instantiateViewController(identifier: "Telematics_ScrollVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func click_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_startEvent(_ sender: UIButton) {
        btn_start.isHidden = true
        btn_end.isHidden = false
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.tripStarted)
        let timestamp = Int(Date().timeIntervalSince1970)
        UserDefaults.standard.set("\(timestamp)", forKey: UserDefaultKeys.tripID)
        UserDefaults.standard.synchronize()
        AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
            print("the person is in their \(vehicle)")
        })
    }
    
    @IBAction func click_endEvent(_ sender: UIButton) {
//        eventId = Events.endEvent
//        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.previousLocation) as? Data{
//            if let loc = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? AEMotionEntity{
//                self.callTelematicsApi(location: loc, eventId: eventId)
//            }
//        }
        AequumMaster.shared.stopGPS()
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.tripID)
        UserDefaults.standard.synchronize()
    }
}

