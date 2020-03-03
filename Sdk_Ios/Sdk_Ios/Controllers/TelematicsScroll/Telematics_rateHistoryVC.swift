//
//  Telematics_rateHistoryVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import Charts
import ObjectMapper

class Telematics_rateHistoryVC: UIViewController {
    @IBOutlet weak var lineChartVw: LineChartView!
    let rateHistoryVM = RateHistory_VM()
    
    @IBOutlet weak var btn_weekly: UIButton!
    @IBOutlet weak var btn_daily: UIButton!
    @IBOutlet weak var btn_monthly: UIButton!
    @IBOutlet weak var btn_yearly: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callTelematicsRatehistoryApi()
    }
    
    @IBAction func click_back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func click_yearly(_ sender: UIButton) {
        sender.isSelected = true
        btn_weekly.isSelected = false
        btn_monthly.isSelected = false
        btn_daily.isSelected = false
        lineChartVw.clear()
        rateHistoryVM.rateValue = RateHistory.yearly
        rateHistoryVM.callGetRateHistoryInfoService = true
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
        btn_weekly.backgroundColor = .clear
        btn_monthly.backgroundColor = .clear
        btn_daily.backgroundColor = .clear
    }
    
    @IBAction func click_daily(_ sender: UIButton){
        sender.isSelected = true
        btn_weekly.isSelected = false
        btn_monthly.isSelected = false
        btn_yearly.isSelected = false
        lineChartVw.clear()
        rateHistoryVM.rateValue = RateHistory.daily
        rateHistoryVM.callGetRateHistoryInfoService = true
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
        btn_weekly.backgroundColor = .clear
        btn_monthly.backgroundColor = .clear
        btn_yearly.backgroundColor = .clear
    }
    
    
    @IBAction func click_weekly(_ sender: UIButton){
        sender.isSelected = true
        btn_daily.isSelected = false
        btn_monthly.isSelected = false
        btn_yearly.isSelected = false
        lineChartVw.clear()
        rateHistoryVM.rateValue = RateHistory.weekly
        rateHistoryVM.callGetRateHistoryInfoService = true
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
        btn_daily.backgroundColor = .clear
        btn_monthly.backgroundColor = .clear
        btn_yearly.backgroundColor = .clear
    }
    
    @IBAction func click_monthly(_ sender: UIButton){
        sender.isSelected = true
        btn_weekly.isSelected = false
        btn_daily.isSelected = false
        btn_yearly.isSelected = false
        lineChartVw.clear()
        rateHistoryVM.rateValue = RateHistory.monthly
        rateHistoryVM.callGetRateHistoryInfoService = true
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
        btn_daily.backgroundColor = .clear
        btn_weekly.backgroundColor = .clear
        btn_yearly.backgroundColor = .clear
    }
}

//MARK:- telematics api
extension Telematics_rateHistoryVC{
    
    func callTelematicsRatehistoryApi(){
        
        if let user = Helper.getUser(){
            rateHistoryVM.info = user
        }else{
            if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.userDic) as? Data{
                if let dic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [String:AnyObject]{
                    if let user = Mapper<UserInfo>().map(JSONObject: dic){
                               Helper.saveUserInfo(user:user)
                           }
                          rateHistoryVM.info = Helper.getUser()
                }
            }
        }
        
        
        
        //For loading indicator
        rateHistoryVM.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                if (self?.rateHistoryVM.isLoading)!  {
                    //self?.showLoader()
                } else {
                    //self?.hideLoader()
                }
            }
        }
        
        //For Alert message
        rateHistoryVM.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                //  self?.hideLoader()
                if let message = self?.rateHistoryVM.alertMessage {
                    // self?.showAlert(self ?? UIViewController(), message: message)
                }
            }
        }
        
        //Response recieved
        rateHistoryVM.responseRecieved = {[weak self] in
            DispatchQueue.main.async {
                self?.updateChartData(values:self?.rateHistoryVM.resultArr ?? [])
            }
        }
        rateHistoryVM.callGetRateHistoryInfoService = true
    }
}


//MARK:- chrat view methods
extension Telematics_rateHistoryVC{
    
    func updateChartData(values:[Double]){
        self.setDataCount(range: UInt32(10),values:values)
    }
    
    func setDataCount(range: UInt32,values:[Double]){
        //        let values = (0..<values.count).map { (i) -> ChartDataEntry in
        //            let val = Double(arc4random_uniform(range) + 3)
        //            return ChartDataEntry(x: Double(i), y: val, icon:nil)
        //        }
        //lineChartVw.x
        var chartArr = [ChartDataEntry]()
        for i in 0..<values.count{
            let val = values[i]
            chartArr.append(ChartDataEntry(x: val, y: val, icon:nil))
        }
        let set1 = LineChartDataSet(entries: chartArr, label: "DataSet 1")
        set1.drawIconsEnabled = false
        
        //set1.lineDashLengths = [5, 2.5]
        lineChartVw.xAxis.gridColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        lineChartVw.leftAxis.gridColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        lineChartVw.rightAxis.gridColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        set1.setColor(.white)
        set1.setCircleColor(.white)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        //set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        // let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
        // ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        // let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        // set1.fillAlpha = 1
        //  set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        //set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        lineChartVw.rightAxis.drawLabelsEnabled = false
        lineChartVw.leftAxis.drawLabelsEnabled = false
        lineChartVw.gridBackgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
        lineChartVw.drawGridBackgroundEnabled = true
        lineChartVw.data = data
    }
    
}
