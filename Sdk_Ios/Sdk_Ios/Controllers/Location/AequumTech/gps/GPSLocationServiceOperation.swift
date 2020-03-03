//
//  GPSLocationServiceOperation.swift
//  AequumFramework
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class GPSLocationServiceOperation: Operation,UNUserNotificationCenterDelegate {
    
    var currentLocation: CLLocation!

    let locManager = CLLocationManager()
    var timer: Timer!

    var foundBeacons = [CLBeacon]()
    var beaconRegion: CLBeaconRegion!
    
    var isRanging = false
    
    override func main() {
        // starting Location Service Provider...
        print("starting gps location provider")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("Permission granted? \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
        
        locManager.delegate = self
        //locManager.startMonitoringSignificantLocationChanges()
//        locManager.distanceFilter = 10.0
        locManager.activityType = .automotiveNavigation
        locManager.desiredAccuracy = kCLLocationAccuracyBest
      //  locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        locManager.allowsBackgroundLocationUpdates = true
        locManager.pausesLocationUpdatesAutomatically = false
        
        locManager.startUpdatingLocation()
        if let uuid = UUID(uuidString: AequumMaster.shared.peripheralUUID){
            beaconRegion = CLBeaconRegion.init(uuid: uuid, major: 101, minor: 2, identifier: uuid.uuidString)
        }
            //CLBeaconRegion(proximityUUID: uuid, major: 101, minor: 2, identifier: uuid.uuidString)
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locManager.requestAlwaysAuthorization()
        }else{
           locManager.startMonitoring(for: beaconRegion)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopGPS(_:)), name: Notification.Name(Constants.kAEStopGPS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startGPS(_:)), name: Notification.Name(Constants.kAEStartGPS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundedGPS(_:)), name: Notification.Name(Constants.kAEEnterBackground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundedGPS(_:)), name: Notification.Name(Constants.kAEEnterForeground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusGPS(_:)), name: Notification.Name(Constants.kAEGPSStatus), object: nil)

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0
                , target: self, selector: #selector(self.timedLocationAndSpeed), userInfo: nil, repeats: true)
            self.timer.fire()
        }
        while(true) {
            sleep(10)
            print("gps tic/toc")
        }
    }

    @objc func timedLocationAndSpeed() {
        guard currentLocation != nil else{
            return
        }
        print("lat: \(currentLocation.coordinate.latitude) long: \(currentLocation.coordinate.longitude) speed: \(currentLocation.speed)")
        let aeLocation = AEMotionEntity()
        aeLocation.latitude = currentLocation.coordinate.latitude
        aeLocation.longitude = currentLocation.coordinate.longitude
        aeLocation.speed = currentLocation.speed
        aeLocation.timestamp = Date()

        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil, userInfo: [Constants.kAELocation: aeLocation as Any])
    }
    
    @objc func statusGPS(_ notification:Notification) {
        print("TODO: gps status")
    }
    
    @objc func backgroundedGPS(_ notification:Notification) {
        //locManager.stopUpdatingLocation()
       // locManager.startMonitoringSignificantLocationChanges()
       // AEPopupNotif.shared.addNotification(title: "Backgrounded, sgnificant GPS only.")

    }

    @objc func foregroundedGPS(_ notification:Notification) {
        print("starting updating going to foreground")
        locManager.startUpdatingLocation()
       // locManager.stopMonitoringSignificantLocationChanges()
       // AEPopupNotif.shared.addNotification(title: "Regular Location Monitoring")
    }

    
    @objc func stopGPS(_ notification:Notification) {
        self.timer.invalidate()
        self.timer = nil
        locManager.stopUpdatingLocation()
    }

    @objc func startGPS(_ notification:Notification) {
        locManager.startUpdatingLocation()
    }
}

extension GPSLocationServiceOperation: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if( status ==  .authorizedWhenInUse ){
            locManager.requestAlwaysAuthorization()
            if !locManager.monitoredRegions.contains(beaconRegion) {
                locManager.startMonitoring(for: beaconRegion)
            }
        } else if status == .notDetermined {
            locManager.requestAlwaysAuthorization()
            if !locManager.monitoredRegions.contains(beaconRegion) {
                locManager.startMonitoring(for: beaconRegion)
            }
        } else if status == .authorizedAlways {
            print("we good..")
            if !locManager.monitoredRegions.contains(beaconRegion) {
                locManager.startMonitoring(for: beaconRegion)
            }
        }
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for location in locations {
            currentLocation = location
            print("dlat: \(location.coordinate.latitude) dlong: \(location.coordinate.longitude) speed: \(location.speed)")
            let aeLocation = AEMotionEntity()
            aeLocation.latitude = location.coordinate.latitude
            aeLocation.longitude = location.coordinate.longitude
            aeLocation.speed = location.speed
            aeLocation.altitude = location.altitude
            aeLocation.timestamp = Date()
            
           // let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil, userInfo: [Constants.kAELocation: aeLocation as Any])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("Did determine state for region \(region)")
        if state == .inside {
            //locManager.startRangingBeacons(in: beaconRegion)
            isRanging = true
            postNotification()
        } else {
            isRanging = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Did start monitoring region: \(region)\n")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locManager.startRangingBeacons(in: beaconRegion)
        print("didEnter")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locManager.stopRangingBeacons(in: beaconRegion)
        print("didExit")
        foundBeacons = []
        locManager.stopUpdatingLocation()
        let aeLocation = AEMotionEntity()
                   aeLocation.latitude = currentLocation.coordinate.latitude
                   aeLocation.longitude = currentLocation.coordinate.longitude
                   aeLocation.speed = currentLocation.speed
                   aeLocation.altitude = currentLocation.altitude
                   aeLocation.timestamp = Date()
         let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kEndEvent), object: nil, userInfo: [Constants.kAELocation: aeLocation as Any])
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        foundBeacons = beacons
        foundBeacons.sort { beacon1, beacon2 -> Bool in
            beacon1.rssi < beacon2.rssi
        }
    }
    
    func postNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Welcome to Insurance app"
        content.body = "Test location"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "EntryNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}
