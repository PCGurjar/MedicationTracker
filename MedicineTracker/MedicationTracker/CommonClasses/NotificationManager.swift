//
//  NotificationManager.swift
//  MedicationTracker
//
//  Created by Poonamchand on 02/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit
import UserNotifications

enum MedicineReminder: String {
    case morning = "MorningMedicineReminder"
    case afternoon = "AfternoonMedicineReminder"
    case evening = "EveningMedicineReminder"
}


class NotificationManager {

    static let sharedInstance = NotificationManager()
    let center = UNUserNotificationCenter.current()
    private init(){
        
    }

    
    // MARK:- remove MedicineReminder
    func removeMedicineNotification(reminderType: MedicineReminder) {
        center.removePendingNotificationRequests(withIdentifiers: [reminderType.rawValue])
    }

    
    // MARK:- Remove all notification
    func removeAllNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [MedicineReminder.morning.rawValue, MedicineReminder.afternoon.rawValue, MedicineReminder.evening.rawValue])
    }
    
    // Used to set the local notification
    func setMorningMedicineNotification(reminderType: MedicineReminder, addingDay: Int) {
        var content = UNMutableNotificationContent()
        content.title = "Medicine Reminder"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        if reminderType == .morning {
            content.body = "Hello this is a reminder you have to take morning medicine"
            dateComponents.hour = 11
        }else if reminderType == .afternoon {
            content.body = "Hello this is a reminder you have to take afternoon medicine"
            dateComponents.hour = 14
        }else{
            content.body = "Hello this is a reminder you have to take evening medicine"
            dateComponents.hour = 20
        }
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // to ignore current day notification
        if addingDay > 0 {
            
        }
        
        // Create the request
        let request = UNNotificationRequest(identifier: reminderType.rawValue, content: content, trigger: trigger)
        
        // Schedule the request with the system.
        center.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }

}
