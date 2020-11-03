//
//  PersistantContainer.swift
//  NextcloudText
//
//  Created by Collin James on 10/26/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation
import CoreData
import os.log

/**
 Sub-class NSPersistentContainer to add convenience functions
 */
class PersistentContainer: NSPersistentContainer {
    /**
     Save the core data context only if there are changes
     - Parameters:
        - backgroundContext: the context to attempt to save
     */
    func saveContext(with backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? self.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            os_log(.debug, "Error saving to CoreData: %s", error.localizedDescription)
        }
    }
}
