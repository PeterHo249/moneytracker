//
//  FinAct+CoreDataClass.swift
//  
//
//  Created by Peter Ho on 9/4/18.
//
//

import Foundation
import CoreData

@objc(FinAct)
public class FinAct: NSManagedObject {
    static let entityName = "FinAct"
    
    static func create() -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: DB.MOC)
    }
    
    static func all() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
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
    
    static func fetchData(forMonth month: String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let beginningDate = CalendarHelper.getBiginningDate(ofMonth: month)
        let endingDate = CalendarHelper.getEndingDate(ofMonth: month)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@", argumentArray: [beginningDate, endingDate])
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchData(forMonth month: String, type: String, cate: String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let beginningDate = CalendarHelper.getBiginningDate(ofMonth: month)
        let endingDate = CalendarHelper.getEndingDate(ofMonth: month)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@ && type == %@ && category == %@", argumentArray: [beginningDate, endingDate, type, cate])
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchData(fromMonth beginningMonth: String, toMonth endingMonth: String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let beginningDate = CalendarHelper.getBiginningDate(ofMonth: beginningMonth)
        let endingDate = CalendarHelper.getEndingDate(ofMonth: endingMonth)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@", argumentArray: [beginningDate, endingDate])
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchData(fromMonth beginningMonth: String, toMonth endingMonth: String, type: String, cate: String) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let beginningDate = CalendarHelper.getBiginningDate(ofMonth: beginningMonth)
        let endingDate = CalendarHelper.getEndingDate(ofMonth: endingMonth)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@ && type == %@ && category == %@", argumentArray: [beginningDate, endingDate, type, cate])
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        }
        catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
}
