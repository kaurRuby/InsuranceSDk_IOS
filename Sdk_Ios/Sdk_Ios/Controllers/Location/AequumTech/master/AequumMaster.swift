//
//  AequumMaster.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications
import UIKit

public struct AEAcceleration {
    public var timestamp: Date!
    public var acceleration: Double!
    
    public init(timestamp: Date, acceleration: Double) {
        self.timestamp = timestamp
        self.acceleration = acceleration
    }
}

public class AequumMaster: NSObject, UNUserNotificationCenterDelegate {
    
    public static let shared = AequumMaster()
    static let queue = OperationQueue()
    public var delegate: AequumDelegate!
    
    var callLocation = true
    
    var gpsprovider = GPSLocationServiceOperation()
    var commprovider = AequumCommOperation()
    var gpsacceleration = GPSAccelerationCalculationOperation()
    
    var aequumQuickStatusViewController: AequumQuickStatusViewController!
    
    var parentController: UIViewController!
    
    var peripheralUUID = ""
    
    public func start(enterprise: String, policy: String, completion: ((String) -> Void)) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeAequumGUI(_:)), name: Notification.Name(Constants.kAEClosingAequumGUI), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.derivedData(_:)), name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.accelerationData(_:)), name: Notification.Name(Constants.kAEAcceleration), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.terminating(_:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.resigning(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        print("starting stuff.")
        AequumMaster.queue.addOperation(self.gpsprovider)
        AequumMaster.queue.addOperation(self.commprovider)
        AequumMaster.queue.addOperation(self.gpsacceleration)
        requestPermission()
        
        completion("Honda CRV")
    }
    
    @objc func resigning(_ notification:Notification) {
        AequumMaster.shared.resignActive()
    }
    
    @objc func terminating(_ notification:Notification) {
        AequumMaster.shared.terminatingApp()
    }
    
    private override init() {
        super.init()
        print("initating")
    }
    
    @objc func closeAequumGUI(_ notification:Notification) {
    }
    
    public func launchAequumQuickStatus(_ parent: UIViewController) {
        aequumQuickStatusViewController = AequumQuickStatusViewController(nibName: "AequumQuickStatusViewController", bundle: Bundle(for:  AequumQuickStatusViewController.self))
        parentController = parent
        parent.present(aequumQuickStatusViewController, animated: true, completion: nil)
    }
    
    public func resignActive() {
        AEPopupNotif.shared.addNotification(title: "Resigning Active")
    }
    
    public func terminatingApp() {
        AEPopupNotif.shared.addNotification(title: "Aequum: Restart App for best insurance rate.")
    }
    
    
    public func goingToBackground() {
        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAEEnterBackground), object: nil, userInfo: nil)
    }
    
    public func goingToForeground() {
        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAEEnterForeground), object: nil, userInfo: nil)
    }
    
    public func stopGPS(){
        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAEStopGPS), object: nil, userInfo: nil)
    }
    
    public func startGPS() {
        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAEStartGPS), object: nil, userInfo: nil)
    }
    
    @objc func accelerationData(_ notification:Notification) {
        guard delegate != nil else {
            return
        }
        let accelDict = notification.userInfo as! Dictionary<String, Any>
        let accelData = accelDict[Constants.kAEAcceleration] as! AEAcceleration
        let timestamp = accelData.timestamp!
        let acceleration = accelData.acceleration!
        delegate.gotAcceleration(timestamp: timestamp, acceleration: acceleration)
    }
    
    @objc func derivedData(_ notification:Notification) {
        guard delegate != nil else {
            return
        }
        let locationDict = notification.userInfo as! Dictionary<String, Any>
        let location = locationDict[Constants.kAELocation] as! AEMotionEntity
        print("got a derived location")
        delegate.gotDerivedLocation(location)
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                    UNUserNotificationCenter.current().delegate = self
                }
        }
    }
    
}

