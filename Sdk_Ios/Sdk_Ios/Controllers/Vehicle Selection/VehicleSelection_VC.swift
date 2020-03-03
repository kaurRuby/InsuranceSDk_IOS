//
//  VehicleSelection_VC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-16.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreBluetooth

class VehicleSelection_VC: UIViewController, CBCentralManagerDelegate{
    
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var txtField_pairedDevices: UITextField!
    enum BLEPeripheralConstants:String{
        case UUIDString = "180f"
        case peripheralName = "A"
    }
    
    let picker1 = UIPickerView()
    
    var selectedCarID = ""
    var peripherals:[CBPeripheral] = []
    var manager:CBCentralManager? = nil
    
    var selectedUdid = ""
    var selectedRow = 0
    
    var deviceSelectedArr : [Bool] = []
    var dic : [String:AnyObject]?
    var userInfo : UserInfo?
    var policyModel : PolicyModel?
    
    @IBOutlet weak var tbleView_cars: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tbleView_cars.rowHeight = UITableView.automaticDimension
        tbleView_cars.estimatedRowHeight = 60
        
        tbleView_cars.tableFooterView = UIView()
        
        if let user = Mapper<UserInfo>().map(JSONObject: dic){
            Helper.saveUserInfo(user:user)
        }
        
        tbleView_cars.register(UINib(nibName: "VehicleTableCell", bundle: Bundle(for: VehicleTableCell.self)), forCellReuseIdentifier: "VehicleTableCell")
        
        createToolbar()
        callPolicyApi()
        scanBLEDevices()
        
    }
    
    @IBAction func click_back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_confirm(_ sender: UIButton){
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

//MARK:- call api
extension VehicleSelection_VC{
    func callPolicyApi(){
        let model = PolicyVModel()
        model.info = Helper.getUser()
        //For loading indicator
        model.updateLoadingStatus = {[weak self] () in
            DispatchQueue.main.async {
                if model.isLoading  {
                    //self?.showLoader()
                } else {
                    //self?.hideLoader()
                }
            }
        }
        
        //For Alert message
        model.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                //  self?.hideLoader()
                if let message = model.alertMessage {
                    // self?.showAlert(self ?? UIViewController(), message: message)
                }
            }
        }
        
        //Response recieved
        model.responseRecieved = {[weak self] in
            self?.policyModel = model.policyModel
            DispatchQueue.main.async {
                self?.tbleView_cars.reloadData()
            }
        }
        model.callGetPolicyInfoService = true
    }
}

//MARK:- table view delegate methods
extension VehicleSelection_VC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tbleView_cars{
            return policyModel?.vehicle?.count ?? 0
        }else{
            return peripherals.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let bundle = Bundle.init(identifier: "com.aequumtech.sdk")
        if tableView == tbleView_cars{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableCell", for: indexPath) as? VehicleTableCell{
                let model  = policyModel?.vehicle?[indexPath.section]
                cell.lbl_name.text = model?.make ?? ""
                cell.img_radio.image =  model?.selected == true ? UIImage(named: "radio_green", in: bundle, compatibleWith: nil) : nil
                cell.backgroundColor = model?.selected == true ? #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 0.3): UIColor.clear
                if let id = UserDefaults.standard.value(forKey: UserDefaultKeys.selectedCarID) as? String{
                    if id == model?.id{
                        cell.img_radio.image = UIImage(named: "radio_green", in: bundle, compatibleWith: nil)
                        cell.backgroundColor =  #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 0.3)
                    }
                }
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell{
                let peripheral = peripherals[indexPath.row]
                cell.img_radio.image =  deviceSelectedArr[indexPath.row] == true ? UIImage(named: "radio_green", in: bundle, compatibleWith: nil) : nil
                cell.lbl_name.text = peripheral.identifier.uuidString
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbleView_cars{
            policyModel?.vehicle?.indices.forEach { policyModel?.vehicle?[$0].selected = false }
            if let model  = policyModel?.vehicle?[indexPath.section]{
                model.selected = true
                policyModel?.vehicle?[indexPath.section] = model
                selectedCarID = model.id ?? ""
                UserDefaults.standard.set(model.make ?? "", forKey: UserDefaultKeys.selectedCarName)
                UserDefaults.standard.set(selectedCarID, forKey: UserDefaultKeys.selectedCarID)
                UserDefaults.standard.synchronize()
            }
            self.tbleView_cars.reloadData()
        }else{
            deviceSelectedArr.indices.forEach { deviceSelectedArr[$0] = false }
            var model  = deviceSelectedArr[indexPath.row]
            model = true
            deviceSelectedArr[indexPath.row] = model
            //self.tbleView_bluetoothDevices.reloadData()
            let peripheral = peripherals[indexPath.row]
            //manager?.connect(peripheral, options: nil)
            AequumMaster.shared.peripheralUUID = peripheral.identifier.uuidString
            // AequumMaster.shared.peripheralUUID = "7f6c8dc83d77134b5a3a1c53f1202b395b04482b"
            
            AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
                print("the person is in their \(vehicle)")
            })
            
            AequumMaster.shared.callLocation = false
            
        }
    }
}

//MARK:- scan bluettoth devices
extension VehicleSelection_VC{
    
    //MARK: BLE Scanning
    func scanBLEDevices(){
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func stopScanForBLEDevices(){
        manager?.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        if(!peripherals.contains(peripheral)){
            deviceSelectedArr.append(false)
            peripherals.append(peripheral)
        }
        if peripherals.count == 1{
            createPickerView()
        }
        picker1.reloadAllComponents()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        print(central.state)
        if (central.state == .poweredOn){
            //manager?.retrieveConnectedPeripherals(withServices: aryCBUUIDS)
            manager?.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 15){[weak self] in
                if self?.manager?.isScanning == true{
                    self?.stopScanForBLEDevices()
                }
            }
        }else{
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        //pass reference to connected peripheral to parent view
        /*  parentView?.mainPeripheral = peripheral
         peripheral.delegate = parentView
         peripheral.discoverServices(nil)
         
         //set the manager's delegate view to parent so it can call relevant disconnect methods
         manager?.delegate = parentView
         
         if let navController = self.navigationController{
         navController.popViewController(animated: true)
         }*/
        //print("Connected to " +  peripheral.name!)
        
        if peripheral.identifier.uuidString == AequumMaster.shared.peripheralUUID{
            if let tripID = UserDefaults.standard.value(forKey: UserDefaultKeys.tripID) as? String{
                if UserDefaults.standard.bool(forKey: UserDefaultKeys.tripStarted) == true{
                    if AequumMaster.shared.callLocation == true{
                        AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
                            print("the person is in their \(vehicle)")
                        })
                        AequumMaster.shared.callLocation = false
                    }
                }
            }else{
                AequumMaster.shared.start(enterprise: "BIG_INSURANCE_COMPANY", policy: "4234ER454356345EF", completion: { (vehicle) in
                    print("the person is in their \(vehicle)")
                })
                AequumMaster.shared.callLocation = false
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print(error!)
    }
    
}

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        layer.addSublayer(border)
    }
}


//MARK:- create picker view methods

extension VehicleSelection_VC{
    
    func createPickerView()
    {
        picker1.delegate = self
        picker1.delegate?.pickerView?(picker1, didSelectRow: 0, inComponent: 0)
        txtField_pairedDevices.inputView = picker1
        picker1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.25)
    }
    
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = #colorLiteral(red: 0, green: 0.5960950851, blue: 0.5294220448, alpha: 1)
        toolbar.backgroundColor = UIColor.clear
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtField_pairedDevices.inputAccessoryView = toolbar
    }
    
    @objc func closePickerView()
    {
        if selectedUdid.isEmpty == false{
            let peripheral = peripherals[selectedRow]
            manager?.connect(peripheral, options: nil)
            //AequumMaster.queue.cancelAllOperations()
            AequumMaster.shared.peripheralUUID = selectedUdid
            UserDefaults.standard.set(selectedUdid, forKey: UserDefaultKeys.selectedUDID)
            UserDefaults.standard.synchronize()
            
        }
        //        let bundle = Bundle.init(identifier: "com.aequumtech.sdk")
        //        img_arrow.image = UIImage(named: "Arrow-drop-down", in: bundle, compatibleWith: nil)
        view.endEditing(true)
    }
}


//MARK:- pickerview and textfield delegate
extension VehicleSelection_VC : UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return peripherals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return peripherals[row].identifier.uuidString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        selectedUdid = peripherals[row].identifier.uuidString
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label:UILabel
        if let v = view as? UILabel{
            label = v
        }
        else{
            label = UILabel()
        }
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 14)
        label.backgroundColor = #colorLiteral(red: 0, green: 0.5960950851, blue: 0.5294220448, alpha: 0.3)
        label.text = peripherals[row].identifier.uuidString
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let bundle = Bundle.init(identifier: "com.aequumtech.sdk")
        img_arrow.image = UIImage(named: "Arrow-drop-down", in: bundle, compatibleWith: nil)
        picker1.reloadAllComponents()
    }
    
}
