//
//  DB.swift
//  moneytracker
//
//  Created by Peter Ho on 9/4/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation
import CoreData

class DB {
    static var MOC: NSManagedObjectContext {
        return CoreDataStack.persistentContainer.viewContext
    }
    
    static func save() {
        if MOC.hasChanges {
            do {
                try MOC.save()
            }
            catch let error as NSError {
                print("Cannot save db \(error)")
            }
        }
    }
}
