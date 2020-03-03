//
//  GPSLocationServiceProvider.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import CoreLocation

class GPSLocationServiceProvider: Operation {
    
    var currentLocation: CLLocation!

    private lazy var locManager: CLLocationManager = {
       let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.requestAlwaysAuthorization()
       return manager
     }()

    override func main() {
        // starting Location Service Provider...
        print("starting gps location provider")
                
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                locManager.allowsBackgroundLocationUpdates = true
                locManager.pausesLocationUpdatesAutomatically = false
                locManager.startUpdatingLocation()
        }
        
        while(true) {
            locManager.startMonitoringSignificantLocationChanges()
            sleep(10)
            print("tic/toc")
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
                
                currentLocation = locManager.location
                locManager.allowsBackgroundLocationUpdates = true
                locManager.pausesLocationUpdatesAutomatically = false
                       
                if currentLocation != nil {
                    print("lat: \(currentLocation.coordinate.latitude) long: \(currentLocation.coordinate.longitude)")
                    let _ = NotificationCenter.default.post(name: Notification.Name("AETimedLocation"), object: nil, userInfo: ["location":currentLocation as Any])
                }
            }
        }
    }
}

extension GPSLocationServiceProvider: CLLocationManagerDelegate {
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("dlat: \(location.coordinate.latitude) dlong: \(location.coordinate.longitude)")
            let _ = NotificationCenter.default.post(name: Notification.Name("AELocation"), object: nil, userInfo: ["location":location as Any])
        }
    }
    
}
