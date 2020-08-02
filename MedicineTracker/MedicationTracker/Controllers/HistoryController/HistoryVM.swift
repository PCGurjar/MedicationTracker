//
//  HistoryVM.swift
//  MedicationTracker
//
//  Created by Poonamchand on 02/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit

protocol HistoryVMDelegate {
    func didDataFoundReloadTable()
}

class HistoryVM {

    var arrMedicationHistory = [ModelHistory]()
    var delegate: HistoryVMDelegate?
    // this is required
    // just depend on this we fetch data and create another array
    var dateToReload = Date()
    
    
    // when view loads first time
    func initialSetUps() {
        self.arrMedicationHistory.removeAll()
        self.dateToReload = self.dateToReload.lastDayOfMonth()
        let days = self.dateToReload.calculateDaysInMonth()
        let currentDay = Date().getCurrentDay()
        
        self.createTemporaryMonthArray(numberOfDays:(days - (days - currentDay)) , forMonth: Date()) { (arrModelHistoryTemp) in
            self.getDataFromDataBaseAndReload(arrModelHistoryTemp: arrModelHistoryTemp)
        }
    }
    
    
    // This will create array for month and fetch data for that month
    // Append this data in finakl array
    func createTemporaryMonthArray(numberOfDays: Int, forMonth: Date, completion: (([ModelHistory])-> Void)) {
        var arrModelHistoryTemp = [ModelHistory]()
        let dateF1 = DateFormatter()
        dateF1.dateFormat = "dd/MM/yyyy"
        let dateF2 = DateFormatter()
        dateF2.dateFormat = "MM/yyyy"
        
        for i in 0 ..< numberOfDays {
            let model = ModelHistory()
            let newDate = Calendar.current.date(byAdding: .day, value: -i, to: forMonth)
            model.date = dateF1.string(from: newDate!)
            model.monthyear = dateF2.string(from: newDate!)
            arrModelHistoryTemp.append(model)
        }
        completion(arrModelHistoryTemp)
    }
    
    // this method call from viewcontroller
    func getPreviousMonthArray() {
        let days = self.dateToReload.calculateDaysInMonth()
        self.createTemporaryMonthArray(numberOfDays:days , forMonth: self.dateToReload) { (arrModelHistoryTemp) in
            self.getDataFromDataBaseAndReload(arrModelHistoryTemp: arrModelHistoryTemp)
        }
    }
    
    // Get data from database and reload
    func getDataFromDataBaseAndReload(arrModelHistoryTemp: [ModelHistory]) {
        DatabaseManager.shared.getAllItemsList(monthYear: self.dateToReload.getFormattedMonth()!) { (arrDatabaseHistoryData) in
            // Decrease date here which is next to fetch
            self.dateToReload = Calendar.current.date(byAdding: .month, value: -1, to: self.dateToReload)!.lastDayOfMonth()
            
            if arrDatabaseHistoryData != nil {
                if arrDatabaseHistoryData!.count > 0 {
                    for modelDatabase in arrDatabaseHistoryData! {
                        for modelFinal in arrModelHistoryTemp {
                            if modelDatabase.date!.lowercased() == modelFinal.date.lowercased() {
                                modelFinal.medicationData = modelDatabase
                                break
                            }
                        }
                    }
                }
            }
            self.arrMedicationHistory.append(contentsOf: arrModelHistoryTemp)
            self.delegate?.didDataFoundReloadTable()
        }
    }
    
}


// This is used for history
class ModelHistory {
    var date = String()
    var monthyear = String()
    var medicationData: MedicationHistory?
}
