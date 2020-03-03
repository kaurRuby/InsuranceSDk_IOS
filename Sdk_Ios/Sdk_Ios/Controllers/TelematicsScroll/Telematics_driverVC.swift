//
//  Telematics_driverVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2020-01-08.
//  Copyright © 2020 Rupinder Kaur. All rights reserved.
//

import UIKit

class Telematics_driverVC: UIViewController {
    
    @IBOutlet weak var lbl_passanger: UILabel!
    @IBOutlet weak var lbl_driver: UILabel!
    @IBOutlet weak var lbl_vehicle: UILabel!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbl_driver.text = "I AM A DRIVER \nI ACCEPT INSURANCE COVERAGE"
        lbl_passanger.text = "I AM A PASSANGER \n I DECLINE INSURANCE COVERAGE"
        
        if let name = UserDefaults.standard.value(forKey: UserDefaultKeys.selectedCarName) as? String{
            lbl_vehicle.text = "  " + name
        }else{
            lbl_vehicle.text = "  No vehicle selected yet"
        }
    }
    
    @IBAction func click_driver(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isDriver)
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_passanger(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isDriver)
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
