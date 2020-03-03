// 
//  Telematics_dashboardVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-26.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_dashboardVC: UIViewController{

    @IBOutlet weak var vwProgress_distracted: UIProgressView!
    @IBOutlet weak var vwProgress_agressive: UIProgressView!
    @IBOutlet weak var vwProgress_night: UIProgressView!
    
    @IBOutlet weak var lbl_tripTotal: UILabel!
    @IBOutlet weak var lbl_parked: UILabel!
    @IBOutlet weak var lbl_idle: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callTelematicsTransactionApi()
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

//MARK:- telematics api
extension Telematics_dashboardVC{
    
    func callTelematicsTransactionApi(){
        let vm = Telematics_dashboardVM()
         if let user = Helper.getUser(){
                   vm.info = user
               }else{
                   if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.userDic) as? Data{
                       if let dic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [String:AnyObject]{
                           if let user = Mapper<UserInfo>().map(JSONObject: dic){
                                      Helper.saveUserInfo(user:user)
                                  }
                                  vm.info = Helper.getUser()
                       }
                   }
               }
        
        //For loading indicator
        vm.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                if vm.isLoading  {
                    //self?.showLoader()
                }else{
                    //self?.hideLoader()
                }
            }
        }
            
        //For Alert message
        vm.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                //  self?.hideLoader()
                if let message = vm.alertMessage {
                    // self?.showAlert(self ?? UIViewController(), message: message)
                }
            }
        }
        
        //Response recieved
        vm.responseRecieved = {[weak self] in
            DispatchQueue.main.async {
                self?.lbl_idle.text = "0"
                self?.lbl_parked.text = "\((vm.resultModel?.parkedSec ?? 0)/3600)" + " min"
                self?.lbl_tripTotal.text = "\(vm.resultModel?.drivenKm ?? 0)" + " km"
                self?.vwProgress_distracted.progress = Float(Double((vm.resultModel?.distracted ?? 0)) * 0.01)
                self?.vwProgress_agressive.progress = Float(Double((vm.resultModel?.aggressive ?? 0)) * 0.01)
                self?.vwProgress_night.progress = Float(Double((vm.resultModel?.night ?? 0)) * 0.01)
            }
        }
        vm.callGetTransactionsDashboardService = true
    }
}
