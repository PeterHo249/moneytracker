//
//  FinAct+CoreDataProperties.swift
//  
//
//  Created by Peter Ho on 9/4/18.
//
//

import Foundation
import CoreData


extension FinAct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinAct> {
        return NSFetchRequest<FinAct>(entityName: "FinAct")
    }

    @NSManaged public var desc: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var category: String?
    @NSManaged public var cost: Int32

}
