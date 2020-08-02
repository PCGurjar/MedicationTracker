//
//  TodayVM.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit

enum TimeFraction: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night" // in night can not take medicine
}


// View model class for todays controller
class TodayVM {

    var todaysMedicationData: MedicationHistory?
    var timeString = TimeFraction.morning
    
    // Set data when view loads
    func setUpInitialData(completion: ((Bool)-> Void)) {
        self.timeString = getTimeString()
        
        self.setUpLocalNotification() // setUps notification
        
        DatabaseManager.shared.getTodaysMedicationData { (mData) in
            self.todaysMedicationData = mData
            
            // to ignore notification
            if (self.todaysMedicationData != nil) {
                if self.timeString == .morning && self.todaysMedicationData?.morningTime != nil {
                    self.ignoreTodaysNotificationDependUpontimeWhenSave(timeType: .morning)
                }else if self.timeString == .afternoon && self.todaysMedicationData?.afternoonTime != nil {
                    self.ignoreTodaysNotificationDependUpontimeWhenSave(timeType: .afternoon)
                }else if self.timeString == .evening && self.todaysMedicationData?.eveningTime != nil {
                    self.ignoreTodaysNotificationDependUpontimeWhenSave(timeType: .evening)
                }
            }
            
            completion(true)
        }
    }
    
    
    // get time string
    func getTimeString()-> TimeFraction {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
            case 6..<12 :
                return TimeFraction.morning
            case 12..<18 :
                return TimeFraction.afternoon
            case 18..<24 :
                return TimeFraction.evening
            default:
                return TimeFraction.night
        }
    }
    
    
    // MARK:- Set up local notification
    func setUpLocalNotification() {
        // remove all first
        NotificationManager.sharedInstance.removeAllNotification()
        
        // set up all
        NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .morning, addingDay: 0)
        NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .afternoon, addingDay: 0)
        NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .evening, addingDay: 0)
    }
    
    
    
    // Ignore notification
    func ignoreTodaysNotificationDependUpontimeWhenSave(timeType: TimeFraction) {
        let currentHour = Date().getCurrentHour()
        
        // remove and fire from next day
        // Means ignore for this day
        if currentHour < 11 {
            NotificationManager.sharedInstance.removeMedicineNotification(reminderType: .morning)
            NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .morning, addingDay: 1)
        }else if currentHour < 14 {
            NotificationManager.sharedInstance.removeMedicineNotification(reminderType: .afternoon)
            NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .afternoon, addingDay: 1)
        }else if currentHour < 20 {
            NotificationManager.sharedInstance.removeMedicineNotification(reminderType: .evening)
            NotificationManager.sharedInstance.setMorningMedicineNotification(reminderType: .evening, addingDay: 1)
        }
    }
}
