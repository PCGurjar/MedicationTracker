//
//  MedicationHistory+CoreDataProperties.swift
//  MedicationTracker
//
//  Created by Poonamchand on 02/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//
//

import Foundation
import CoreData


extension MedicationHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicationHistory> {
        return NSFetchRequest<MedicationHistory>(entityName: "MedicationHistory")
    }

    @NSManaged public var afternoonTime: String?
    @NSManaged public var date: String?
    @NSManaged public var eveningTime: String?
    @NSManaged public var morningTime: String?
    @NSManaged public var score: Int16
    @NSManaged public var monthYear: String?

}
