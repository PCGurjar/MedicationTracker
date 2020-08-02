//
//  UIUtils.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//



import Foundation
import UIKit

// This class is used for common functions
final public class UIUtils {
    
    class func getColorDependUponScore(value: Int)-> UIColor {
        if value > 50 && value < 100{
            return UIColor.orange
        }else if value < 50 {
            return UIColor.red
        }else{
            return UIColor.green
        }
    }
    
}


