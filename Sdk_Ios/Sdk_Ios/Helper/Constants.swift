//
//  Constants.swift
//  AequumTech
//
//  Created by Aleksandar Matijaca on 2019-11-27.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation

class Constants {
    
    static let kAEAcceleration: String = "kAEAcceleration"
    static let kAETimedLocationAndSpeed: String = "kAETimedLocationAndSpeed"
    static let kEndEvent: String = "kEndEvent"
    static let kAELocation: String = "kAELocation"
    static let kAEClosingAequumGUI: String = "kAEClosingAequumGUI"
    static let kAEStopGPS: String = "kAEStopGPS"
    static let kAEStartGPS: String = "kAEStartGPS"
    static let kAEEnterBackground: String = "kAEEnterBackground"
    static let kAEEnterForeground: String = "kAEEnterForeground"
    static let kAEGPSStatus: String = "kAEGPSStatus"
}

//events

class Events {
    static let startEvent = 1
    static let endEvent = 2
    static let speedEvent = 3
    static let distractEvent = 4
    static let hardAccEvent = 5
    static let hardBrakeEvent = 6
    static let normalEvent = 9
    static let maxRateEvent = 12
    static let maxDayEvent = 13
    static let calculateEvent = 15
    static let corneringEvent = 7
    static let idlingEvent = 8
}

//rate history
class RateHistory {
    static let defaultValue = 0
    static let daily = 1
    static let weekly = 2
    static let monthly = 3
    static let yearly = 4
}
