//
//  Extensions.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import Foundation
import UIKit

// View extension for round corners
// To add some methods
extension UIView {

    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 3

        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
   
}


// Extenstion for date
// to update values
extension Date {
    
    // this is used to get any daye in following formate
    // dd/mm/yyyy
    func getFormattedDate()-> String? {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd/MM/yyyy"
        return dateFormate.string(from: self)
    }
    
    // this is used to get any daye in following formate
    // mm/yyyy
    func getFormattedMonth()-> String? {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MM/yyyy"
        return dateFormate.string(from: self)
    }
    
    // this is used to get current time in formate
    // hh:mm am/Pm
    func getFormatttedCurrentTime()-> String? {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "hh:mm a"
        return dateFormate.string(from: self)
    }
    
    // Usde to calculate days in perticular month of year
    func calculateDaysInMonth()-> Int {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: self)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        return days
    }
    
    // Usde to calculate days in perticular month of year
    func getCurrentDay()-> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    // used to get last date of mpnth
    func lastDayOfMonth() -> Date {
       let calendar = Calendar.current
       let components = DateComponents(day:1)
       let startOfNextMonth = calendar.nextDate(after:self, matching: components, matchingPolicy: .nextTime)!
       return calendar.date(byAdding:.day, value: -1, to: startOfNextMonth)!
    }
    
    // Used to calculate hour in perticular date
    func getCurrentHour()-> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
   
}
