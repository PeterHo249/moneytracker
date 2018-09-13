//
//  SavingAct+CoreDataClass.swift
//  
//
//  Created by Peter Ho on 9/12/18.
//
//

import Foundation
import CoreData

@objc(SavingAct)
public class SavingAct: NSManagedObject {
    static let entityName = "SavingAct"
    
    static func create() -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: DB.MOC)
    }
    
    static func all() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func allAndCalcInterest() -> [NSManagedObject] {
        let activities = all()
        let now = Date()
        var month = 0
        for activity in activities.reversed() {
            if (activity as! SavingAct).type == "Deposit" && (activity as! SavingAct).isInterested {
                while (now as NSDate).timeIntervalSince((activity as! SavingAct).startDate! as Date) >= PeriodRef.fromString(string: (activity as! SavingAct).period!).rawValue {
                    switch PeriodRef.fromString(string: (activity as! SavingAct).period!) {
                    case .Month1:
                        month = 1
                    case .Month3:
                        month = 3
                    case .Month6:
                        month = 6
                    case .Month12:
                        month = 12
                    case .Month24:
                        month = 24
                    }
                    let interest = Int(Double((activity as! SavingAct).cost) * (activity as! SavingAct).rate / 12 * Double(month))
                    (activity as! SavingAct).cost += Int32(interest)
                    (activity as! SavingAct).startDate?.addingTimeInterval(PeriodRef.fromString(string: (activity as! SavingAct).period!).rawValue)
                    var saving = UserDefaults(suiteName: "group.peterho.moneytracker")!.integer(forKey: savingKeyName)
                    saving += interest
                    UserDefaults(suiteName: "group.peterho.moneytracker")!.set(saving, forKey: savingKeyName)
                }
            }
        }
        
        DB.save()
        return activities
    }
}
