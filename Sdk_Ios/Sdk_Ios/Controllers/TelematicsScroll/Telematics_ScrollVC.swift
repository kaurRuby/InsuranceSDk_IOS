//
//  Telematics_ScrollVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_ScrollVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var img_onOff: UIImageView!
    var dic : [String:AnyObject]?
    var userInfo : UserInfo?
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: dic)
        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.userDic)
        
        // Do any additional setup after loading the view.
        if let user = Mapper<UserInfo>().map(JSONObject: dic){
            Helper.saveUserInfo(user:user)
        }
        userInfo = Helper.getUser()
        
        if let udid = UserDefaults.standard.value(forKey:  UserDefaultKeys.selectedUDID) as? String{
            AequumMaster.shared.peripheralUUID = udid
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.tripStarted) == true{
            if AequumMaster.shared.callLocation == true{
                AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
                                                  print("the person is in their \(vehicle)")
                })
                AequumMaster.shared.callLocation = false
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let driver = UserDefaults.standard.bool(forKey: UserDefaultKeys.isDriver)
        let bundle = Bundle.init(identifier: "com.aequumtech.sdk")
        if driver == true{
            self.img_onOff.image = UIImage(named: "On", in: bundle, compatibleWith: nil)
        }else{
            self.img_onOff.image = UIImage(named: "Off", in: bundle, compatibleWith: nil)
        }
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func click_back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_openDriverSelection(_ sender: UIButton) {
        if let vc = UIStoryboard.init(name: "Telematics", bundle: Bundle(for: Telematics_driverVC.self)).instantiateViewController(identifier: "Telematics_driverVC") as? Telematics_driverVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK:- scroll view delegate
extension Telematics_ScrollVC : UIScrollViewDelegate{
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0{
            page = 0
        }else if scrollView.contentOffset.x == UIScreen.main.bounds.size.width{
            page = 1
        }else if scrollView.contentOffset.x == 2 * UIScreen.main.bounds.size.width{
            page = 2
        }else if scrollView.contentOffset.x == 3 * UIScreen.main.bounds.size.width{
            page = 3
        }
        pageControl.currentPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0{
            page = 0
        }else if scrollView.contentOffset.x == UIScreen.main.bounds.size.width{
            page = 1
        }else if scrollView.contentOffset.x == 2 * UIScreen.main.bounds.size.width{
            page = 2
        }else if scrollView.contentOffset.x == 3 * UIScreen.main.bounds.size.width{
            page = 3
        }
        pageControl.currentPage = page
    }
}

