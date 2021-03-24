//
//  CoreDataStack.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/20/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "LivingWithEndo")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
