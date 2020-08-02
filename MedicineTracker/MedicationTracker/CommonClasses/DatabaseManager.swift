//
//  DatabaseManager.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit
import CoreData

// this will fire event after update
protocol DatabaseManagerDelegates {
    func didDataSaved()
}

// Singleton class to handle Database
class DatabaseManager {

    static let shared = DatabaseManager()
    var delegate: DatabaseManagerDelegates?
    
    private init() {
    }
    
    
    // Get current date medicationData
    func getTodaysMedicationData(completion: ((MedicationHistory?)-> Void)) {
        if let appD = UIApplication.shared.delegate as? AppDelegate {
            // get current date
            if let currentDate = Date().getFormattedDate() {
                let managedContext = appD.persistentContainer.viewContext
                // create fetch request
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MedicationHistory")
                // predicate to search by date
                fetchRequest.predicate = NSPredicate(format: "date = %@", currentDate)
                
                // Fetch all data here and made list
                do {
                    let result = try managedContext.fetch(fetchRequest).first
                    // Create array of model
                    if let object = result as? MedicationHistory {
                        completion(object)
                    }else{
                        completion(nil)
                    }
                }
                catch {
                    print("Request failed!")
                    completion(nil)
                }
            }
        }
    }
    
    
    // Get all saved medicine data
    // Depends on month
    func getAllItemsList(monthYear: String, completion: (([MedicationHistory]?)-> Void)) {
        if let appD = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appD.persistentContainer.viewContext
            // create fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MedicationHistory")
            
            // predicate to search by date
            fetchRequest.predicate = NSPredicate(format: "monthYear = %@", monthYear)
            
            // Fetch all data here and made list
            do {
                var arrMedicationHistory = [MedicationHistory]()
                let result = try managedContext.fetch(fetchRequest)
                // Create array of model
                for data in result {
                    if let object = data as? MedicationHistory {
                        arrMedicationHistory.append(object)
                    }
                }
                completion(arrMedicationHistory)
            }
            catch {
                print("Request failed!")
                completion(nil)
            }
        }
    }
    
    
    // save current date data
    func saveCurrentdateMedicationdata(mTime: String?, aTime:String?, eTime: String?) {
        guard let appD = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // get current date
        if let currentDate = Date().getFormattedDate() {
            if let month = Date().getFormattedMonth() {
                // set score
                var score = 0
                if mTime != nil {
                    score += 30
                }
                if aTime != nil {
                    score += 30
                }
                if eTime != nil {
                    score += 40
                }
                
                let managedContext = appD.persistentContainer.viewContext
                
                // create fetch request
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MedicationHistory")
                
                // entity
                let entity = NSEntityDescription.entity(forEntityName: "MedicationHistory", in: managedContext)
                
                // predicate to search by date
                fetchRequest.predicate = NSPredicate(format: "date = %@", currentDate)
                
                // Fetch all data here and made list
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    
                    // update value in NSManagedObject
                    func updateNSManagedObject(newObject: NSManagedObject) {
                        newObject.setValue(currentDate, forKey: "date")
                        newObject.setValue(score, forKey: "score")
                        newObject.setValue(month, forKey: "monthYear")
                        
                        if mTime != nil {
                           newObject.setValue(mTime!, forKey: "morningTime")
                        }
                        if aTime != nil {
                            newObject.setValue(aTime!, forKey: "afternoonTime")
                        }
                        if eTime != nil {
                            newObject.setValue(eTime!, forKey: "eveningTime")
                        }
                    }
                    
                    // set final values in database
                    if let objectToUpdate = result.first as? NSManagedObject {
                        // update
                        updateNSManagedObject(newObject: objectToUpdate)
                    }else{
                        // add
                        let objectToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
                        updateNSManagedObject(newObject: objectToAdd)
                    }
                    do {
                        try managedContext.save()
                        delegate?.didDataSaved() // save data
                    }
                    catch {
                        print("Request failed!")
                    }
                }
                catch {
                    print("Request failed!")
                }
            }
        }
    }
    
    
}
