//
//  Slide0ViewController.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-11-20.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

class Slide0ViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var tableView: UITableView!
    var acceleration = Dictionary<Date, AEAcceleration>()
    var sortedAcceleration = [(key: Date, value: AEAcceleration)]()

    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        tableView.register(UINib(nibName: "AccelerationTableViewCell", bundle: Bundle(for: AccelerationTableViewCell.self)), forCellReuseIdentifier: "accelerationcell")
        tableView.register(UINib(nibName: "LocationServiceTableViewCell", bundle: Bundle(for: LocationServiceTableViewCell.self)), forCellReuseIdentifier: "gpslocation")

        NotificationCenter.default.addObserver(self, selector: #selector(self.accelerationData(_:)), name: Notification.Name(Constants.kAEAcceleration), object: nil)

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.timedClear), userInfo: nil, repeats: true)
            self.timer.fire()
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

    func everythingClear() {
        
        AequumMaster.shared.stopGPS()
        sleep(1)
        acceleration = Dictionary<Date, AEAcceleration>()
        sortedAcceleration = [(key: Date, value: AEAcceleration)]()
        self.tableView.reloadData()
        AequumMaster.shared.startGPS()

    }
    
    @objc func timedClear() {
        
        everythingClear()
        self.tableView.reloadData()

    }

    
    @objc func accelerationData(_ notification:Notification) {
        
        let accelDict = notification.userInfo as! Dictionary<String, Any>
        let aeccelData: AEAcceleration = accelDict[Constants.kAEAcceleration] as! AEAcceleration

        DispatchQueue.main.async {
            
            self.acceleration[Date()] = aeccelData
            self.sortedAcceleration = self.acceleration.sorted(by: { (arg0: (Date, AEAcceleration), arg1: (Date, AEAcceleration)) -> Bool in
                arg0.0 > arg1.0
            })
            
            while self.acceleration.count >= 200 {
                let lastKey = self.sortedAcceleration.last?.key
                self.acceleration.removeValue(forKey: lastKey!)
            }
            
            self.tableView.reloadData()
                        
        }

        
        /*
        let indexPath = NSIndexPath(row: 0, section: 1)

        tableView.beginUpdates()
        tableView.reloadRows(at: [(indexPath as IndexPath)], with: UITableView.RowAnimation.automatic) //try other animations
        tableView.endUpdates()
        */
    }

}




extension Slide0ViewController: UITableViewDelegate {
    
}

extension Slide0ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Accelerometer Device"
        }
        if section == 1 {
            return "GPS"
        }

        return ""
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accelerationcell") as! AccelerationTableViewCell
            cell.accelArrayCount.text = "# \(sortedAcceleration.count)"
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gpslocation") as! LocationServiceTableViewCell
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    

    
}

extension Slide0ViewController: Slide0Protocol {
    func haveNewLocation() {
        self.tableView.reloadData()
    }
    
    
    func clearAccelerometer() {
        everythingClear()
    }

}


