//
//  CoreDataStack.swift
//  moneytracker
//
//  Created by Peter Ho on 9/4/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "moneytracker")
        
        let appName = "moneytracker"
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.peterho.moneytracker")!.appendingPathComponent("moneytracker.sqlite")
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.peterho.moneytracker")!.appendingPathComponent("moneytracker.sqlite"))]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
