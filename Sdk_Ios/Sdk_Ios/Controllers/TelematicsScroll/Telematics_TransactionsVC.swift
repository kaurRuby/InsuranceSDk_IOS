//
//  Telematics_TransactionsVC.swift
//  Sdk_Ios
//
//  Created by Rupinder Kaur on 2019-12-23.
//  Copyright © 2019 Rupinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class Telematics_TransactionsVC: UIViewController {
    
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var htConstrnt: NSLayoutConstraint!
    @IBOutlet weak var vw_dateFilter: UIView!
    @IBOutlet weak var tableView: UITableView!
    var payloadArr = [TransactionModel]()
    
    @IBOutlet weak var txtField_startDate: UITextField!
    @IBOutlet weak var txtField_endDate: UITextField!
    
    var vm = TransactionsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_endDate.delegate = self
        txtField_startDate.delegate = self
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TransactionCell", bundle: Bundle(for: AccelerationTableViewCell.self)), forCellReuseIdentifier: "TransactionCell")
        tableView.tableFooterView = UIView()
        vm.fromStr = "2019-12-01"
        vm.toStr = "2019-12-31"
        htConstrnt.constant = 0
        self.callTelematicsTransactionApi()
    }
    
    
    @IBAction func click_filter(_ sender: UIButton) {
        vw_dateFilter.isHidden = false
        htConstrnt.constant = 75
    }
  
    @objc func handleDatePicker(sender: UIDatePicker) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      txtField_startDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDatepicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtField_endDate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func click_applyFilter(_ sender: UIButton) {
        vw_dateFilter.isHidden = true
        htConstrnt.constant = 0
        vm.fromStr = txtField_startDate.text == "yyyy-mm-dd" ? "" : (txtField_startDate.text ?? "")
        vm.toStr = txtField_endDate.text == "yyyy-mm-dd" ? "" : (txtField_endDate.text ?? "")
        self.callTelematicsTransactionApi()
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

extension Telematics_TransactionsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        // #warning Incomplete implementation, return the number of sections
        return payloadArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell{
            cell.lbl_date.text = payloadArr[indexPath.section].fromDate ?? ""
            cell.lbl_car.text = payloadArr[indexPath.section].car ?? ""
            cell.lbl_rate.text = "$" + "\(payloadArr[indexPath.section].cost ?? 0)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


extension Telematics_TransactionsVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtField_startDate{
           let datePickerView = UIDatePicker()
                  datePickerView.datePickerMode = .date
                  txtField_startDate.inputView = datePickerView
                  datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        }else{
            let datePickerView = UIDatePicker()
                   datePickerView.datePickerMode = .date
                   txtField_endDate.inputView = datePickerView
                   datePickerView.addTarget(self, action: #selector(handleDatepicker(sender:)), for: .valueChanged)
        }
    }
}

//MARK:- telematics api
extension Telematics_TransactionsVC{
    
    func callTelematicsTransactionApi(){
        
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
                if self?.vm.isLoading ?? false  {
                    //self?.showLoader()
                } else {
                    //self?.hideLoader()
                }
            }
        }
        
        //For Alert message
        vm.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                //  self?.hideLoader()
                if let message = self?.vm.alertMessage {
                    // self?.showAlert(self ?? UIViewController(), message: message)
                }
            }
        }
        
        //Response recieved
        vm.responseRecieved = {[weak self] in
            DispatchQueue.main.async {
                self?.payloadArr = self?.vm.resultArr ?? []
            
                if self?.payloadArr.count == 0{
                    self?.tableView.isHidden = true
                    self?.btn_filter.isHidden = true
                }else{
                    self?.tableView.isHidden = false
                    self?.btn_filter.isHidden = false
                    self?.tableView.reloadData()
                }
            }
        }
        vm.callGetTransactionsService = true
    }
}
