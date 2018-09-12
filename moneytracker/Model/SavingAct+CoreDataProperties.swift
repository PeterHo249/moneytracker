//
//  SavingAct+CoreDataProperties.swift
//  
//
//  Created by Peter Ho on 9/12/18.
//
//

import Foundation
import CoreData


extension SavingAct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingAct> {
        return NSFetchRequest<SavingAct>(entityName: "SavingAct")
    }

    @NSManaged public var desc: String?
    @NSManaged public var cost: Int32
    @NSManaged public var type: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isInterested: Bool
    @NSManaged public var rate: Double
    @NSManaged public var period: String?
    @NSManaged public var startDate: NSDate?

}
