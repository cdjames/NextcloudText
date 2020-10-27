//
//  PersistantContainer.swift
//  NextcloudText
//
//  Created by Collin James on 10/26/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation
import CoreData

// sub-class to add convenience functions
class PersistentContainer: NSPersistentContainer {


    func saveContext(with backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
