//
//  TelematicsDashboardVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2020-01-13.
//  Copyright © 2020 Rupinder Kaur. All rights reserved.
//

import UIKit
import Charts
import ObjectMapper
import CoreLocation

class TelematicsDashboardVC: UIViewController{
    @IBOutlet weak var lbl_currentRate: UILabel!
    
    var userInfo : UserInfo?
    var selectedCarId = ""
    
    var dic : [String:AnyObject]?
    
    var time = 0
    var tripId = ""
    var eventId = 0
    
    @IBOutlet weak var pieChartVw: PieChartView!
    
    var telematicVM = TelematicVModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timedData(_:)), name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.endEvent(_:)), name: Notification.Name(Constants.kEndEvent), object: nil)
        
        if let user = Mapper<UserInfo>().map(JSONObject: dic){
            Helper.saveUserInfo(user:user)
        }
        userInfo = Helper.getUser()
        
        if let carID = UserDefaults.standard.value(forKey: UserDefaultKeys.selectedCarID) as? String{
            selectedCarId = carID
        }
        self.setup(pieChartView: pieChartVw)
        self.updateChartData()
        callTelematicsCurrentRateApi()
        
    }
    
    @objc func endEvent(_ notification:Notification) {
        let locationDict = notification.userInfo as! Dictionary<String, Any>
               let location = locationDict[Constants.kAELocation] as! AEMotionEntity
               
               if let time1 = UserDefaults.standard.value(forKey: UserDefaultKeys.tripTime) as? Int{
                   time = time1 + 1
                   UserDefaults.standard.set(time, forKey: UserDefaultKeys.tripTime)
                   UserDefaults.standard.synchronize()
               }else{
                   time = time + 1
                   UserDefaults.standard.set(time, forKey: UserDefaultKeys.tripTime)
                   UserDefaults.standard.synchronize()
               }
               print("got a timed location")
               DispatchQueue.main.async{
                   //self.lbl_location.text = "\(location.latitude ?? 0.0)" + " , " + "\(location.longitude ?? 0.0)"
                   self.pieChartVw.centerText = String(format: "%.2f", location.speed ?? 0.0) + " m/s"
               }
                eventId = Events.endEvent
                self.callTelematicsApi(location: location, eventId: self.eventId)
        
    }
    
    @objc func timedData(_ notification:Notification) {
        let locationDict = notification.userInfo as! Dictionary<String, Any>
        let location = locationDict[Constants.kAELocation] as! AEMotionEntity
        
        if let time1 = UserDefaults.standard.value(forKey: UserDefaultKeys.tripTime) as? Int{
            time = time1 + 1
            UserDefaults.standard.set(time, forKey: UserDefaultKeys.tripTime)
            UserDefaults.standard.synchronize()
        }else{
            time = time + 1
            UserDefaults.standard.set(time, forKey: UserDefaultKeys.tripTime)
            UserDefaults.standard.synchronize()
        }
        print("got a timed location")
        DispatchQueue.main.async{
            //self.lbl_location.text = "\(location.latitude ?? 0.0)" + " , " + "\(location.longitude ?? 0.0)"
            self.pieChartVw.centerText = String(format: "%.2f", location.speed ?? 0.0) + " m/s"
        }
        if eventId == 0{
            eventId = Events.startEvent
        }else{
            eventId = Events.normalEvent
            if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.previousLocation) as? Data{
                if let previousLoc = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? AEMotionEntity{
                    let previousSpeed = previousLoc.speed ?? 0.0
                    let increase = previousSpeed + previousSpeed * 0.20
                    if location.speed ?? 0.0 >= increase{
                        eventId = Events.speedEvent
                    }
                }
            }
        }
        self.callTelematicsApi(location: location, eventId: self.eventId)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK:- telematics api
extension TelematicsDashboardVC{
    
    func callTelematicsApi(location:AEMotionEntity,eventId:Int){
        
        telematicVM.info = Helper.getUser()
        telematicVM.paramDic = self.prepareParamDic(location: location, eventId: eventId)
        //For loading indicator
        telematicVM.updateLoadingStatus = {[weak self] () in
            DispatchQueue.main.async {
                if self?.telematicVM.isLoading ?? false  {
                    //self?.showLoader()
                } else {
                    //self?.hideLoader()
                }
            }
        }
        
        //For Alert message
        telematicVM.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                //  self?.hideLoader()
                if let message = self?.telematicVM.alertMessage {
                    // self?.showAlert(self ?? UIViewController(), message: message)
                }
            }
        }
        
        //Response recieved
        telematicVM.responseRecieved = {[weak self] in
            DispatchQueue.main.async {
                if eventId == Events.endEvent{
                    UserDefaults.standard.removeObject(forKey: UserDefaultKeys.tripStarted)
                    UserDefaults.standard.removeObject(forKey: UserDefaultKeys.tripID)
                    AequumMaster.shared.callLocation = true
                }
            }
        }
        telematicVM.callPostTelematicsInfoService = true
    }
    
    func prepareParamDic(location:AEMotionEntity,eventId:Int) -> [String:AnyObject]{
        var dic = [String:AnyObject]()
        
        //prepare metadata
        var metadataDic = [String:AnyObject]()
        metadataDic["category"]  = "telematics" as AnyObject
        metadataDic["subcategory"] = "tripevent" as AnyObject
        metadataDic["deviceID"] = UIDevice.current.identifierForVendor?.uuidString as AnyObject
        metadataDic["policy"] =  (userInfo?.policy ?? "") as AnyObject
        metadataDic["tenantID"] = "2" as AnyObject
        metadataDic["carID"] =  self.selectedCarId as AnyObject
        metadataDic["id1"] = (userInfo?.id1 ?? "") as AnyObject
        metadataDic["id2"] = (userInfo?.id2 ?? "") as AnyObject
        var tripId = ""
        if let tripID = UserDefaults.standard.value(forKey: UserDefaultKeys.tripID) as? String{
            tripId = tripID
        }else{
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.tripStarted)
            let timestamp = Int(Date().timeIntervalSince1970)
            tripId = "\(timestamp)"
            UserDefaults.standard.set("\(timestamp)", forKey: UserDefaultKeys.tripID)
            UserDefaults.standard.synchronize()
        }
        metadataDic["tripID"] =  tripId as AnyObject
        let timeStamp = Int(Date().timeIntervalSince1970)
        metadataDic["timestamp"] =  "\(timeStamp * 1000)" as AnyObject
        metadataDic["action"] = "ACTION_ACT" as AnyObject
        metadataDic["event"] = eventId as AnyObject
        
        var reason = ""
        if eventId == 12 || eventId == 13{
            reason = "any reason"
        }
        metadataDic["reason"] = reason as AnyObject
        metadataDic["driver"] =  "driver" as AnyObject
        metadataDic["version"] =  "v01" as AnyObject
        
        //acceleration dic
        var speedDic = [String:AnyObject]()
        speedDic["current_speed"] = (Int(location.speed) ?? 0 > 0 ? Int(location.speed) ?? 0 : 10) as AnyObject
        //gps
        var locationDic = [String:AnyObject]()
        locationDic["altitude"] = (Int(location.altitude ?? 1)) as AnyObject
        // locationDic["location"] = "12450.12550" as AnyObject
        locationDic["location"] =  ("\(location.latitude ?? 0.0)" + "|" + "\(location.longitude ?? 0.0)") as AnyObject
        
        //general
        var infoDic = [String:AnyObject]()
        var timeinSec = 0
        if let time1 = UserDefaults.standard.value(forKey: UserDefaultKeys.tripTime) as? Int{
            timeinSec = time1 * 60
        }
        var distance = 0.0
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.previousLocation) as? Data{
            if let previousLoc = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? AEMotionEntity{
                let previousLocation = CLLocation.init(latitude: previousLoc.latitude, longitude: previousLoc.longitude)
                let newLoc = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
                distance = previousLocation.distance(from: newLoc)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: location)
                UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.previousLocation)
                UserDefaults.standard.synchronize()
            }
        }else{
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: location)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.previousLocation)
            UserDefaults.standard.synchronize()
        }
        
        distance = distance/1000
        let hoursRate = timeinSec/3600
        var rate = 0
        if hoursRate == 0{
            infoDic["current_rate"] = "0.1" as AnyObject
        }else{
            infoDic["current_rate"] = "\(distance/Double(hoursRate))" as AnyObject
        }
        if distance == 0.0{
            distance = 0.2
        }
        infoDic["drivenkm"] = distance as AnyObject
        infoDic["drivensec"] = timeinSec as AnyObject
        
        //payload
        var payloadDic = [String:AnyObject]()
        payloadDic["accelerometer"] = speedDic as AnyObject
        payloadDic["gps"] = locationDic as AnyObject
        payloadDic["general"] = infoDic as AnyObject
        
        dic["metadata"] = metadataDic as AnyObject
        dic["payload"] = payloadDic as AnyObject
        
        var dataDic = [String:AnyObject]()
        dataDic["data"] = [dic] as AnyObject
        return dataDic
    }
    
}

//MARK:- chart setup
extension TelematicsDashboardVC{
    
    func setup(pieChartView chartView: PieChartView){
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.63
        chartView.transparentCircleRadiusPercent = 0.65
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        chartView.legend.enabled = false
        chartView.drawCenterTextEnabled = true
        chartView.centerText = "0.0 m/s"
        /*let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
         paragraphStyle.lineBreakMode = .byTruncatingTail
         paragraphStyle.alignment = .center
         
         let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
         centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
         .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
         centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
         .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
         centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
         .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
         chartView.centerAttributedText = centerText;*/
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //chartView.legend = l
    }
    
    func updateChartData(){
        self.setDataCount(5, range: UInt32(35))
    }
    
    func setDataCount(_ count: Int, range: UInt32){
        let arr = [7,14,28,29,35]
        let entries = (0..<count).map{(i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(arr[i]),
                                     label: "",
                                     icon:nil)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        // pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.clear)
        pieChartVw.data = data
        pieChartVw.highlightValues(nil)
    }
    
}


//MARK:- telematics  current rate

extension TelematicsDashboardVC{
    
    func callTelematicsCurrentRateApi(){
        let vm = Telematics_CurrentRateVM()
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
        vm.updateLoadingStatus = {[weak self] () in
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
                self?.lbl_currentRate.text = "$" + "\(vm.resultModel?.currentBalance ?? 0.0)"
            }
        }
        vm.callGetTransactionsCurrentRateService = true
    }
    
}
