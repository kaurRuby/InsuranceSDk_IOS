//
//  AEPopupNotif.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-11-11.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import UserNotifications

struct AENotification {
    var id: String
    var title: String
}


class AEPopupNotif: NSObject {
    
    var notifications = [AENotification]()
    static public var shared = AEPopupNotif()
    
    private override init() {
        super.init()
        print("initting")
    }

    func addNotification(title: String) -> Void {

        #if DEBUG
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"//this your string date format
            let convertedDate = dateFormatter.string(from: Date())
            notifications.append(AENotification(id: UUID().uuidString, title: "\(title) \(convertedDate)"))
            scheduleNotifications()
        #else
            notifications.append(AENotification(id: UUID().uuidString, title: title))
            scheduleNotifications()
        #endif
    }
    
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
        
        notifications = [AENotification]()
        
    }
    
}
