//
//  LocationServiceTableViewCell.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-23.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServiceTableViewCell: UITableViewCell {

    
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var locationDateLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    
    @IBOutlet var numberOfLocations: UILabel!
    var delegate: Slide0Protocol!
    var displayDerived = Dictionary<Date, AEMotionEntity>()
    var sortedDerived =  [(key: Date, value: AEMotionEntity)]()
    var timer: Timer!
    var stringLatitude: String = ""
    var stringLongitude: String = ""
    var stringTimestamp: Date!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AequumMaster.shared.delegate = self

        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.autoClear), userInfo: nil, repeats: true)
            self.timer.fire()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func autoClear() {
        
        AequumMaster.shared.stopGPS()
        sleep(1)
        displayDerived = Dictionary<Date, AEMotionEntity>()
        sortedDerived = [(key: Date, value: AEMotionEntity)]()
        AequumMaster.shared.startGPS()

    }

}



extension LocationServiceTableViewCell: AequumDelegate {
    
    func gotAcceleration(timestamp: Date, acceleration: Double) {
        
    }
    
    
    
    func gotDerivedLocation(_ location: AEMotionEntity) {
        
        DispatchQueue.main.async {
            
            let useDate = Date()
            self.displayDerived[useDate] = location
            
            self.sortedDerived = self.displayDerived.sorted(by: { (arg0: (Date, AEMotionEntity), arg1: (Date, AEMotionEntity)) -> Bool in
                arg0.0 > arg1.0
            })
            
            
            if self.displayDerived.count >= 20 {
                let lastKey = self.sortedDerived.last?.key
                self.displayDerived.removeValue(forKey: lastKey!)
            }
            
            let dDate = self.sortedDerived[0].key
            let dLat = self.sortedDerived[0].value.latitude
            let dLon = self.sortedDerived[0].value.longitude
            self.timestampLabel.text = Utils.convertToDisplayableTime(dDate)
            self.latitudeLabel.text = String(format: "%.10f", arguments: [dLat!])
            self.longitudeLabel.text = String(format: "%.10f", arguments: [dLon!])
            self.locationDateLabel.text = Utils.convertToDisplayableTime(location.timestamp)
            self.speedLabel.text = String(format: "%.4f", arguments: [location.speed])
            self.delegate.haveNewLocation()
            self.numberOfLocations.text = "# of locations \(self.displayDerived.count)"
        }
        
    }
    
    func gotTimedLocation(_ location: AEMotionEntity) {

        
    }
    
    
}

