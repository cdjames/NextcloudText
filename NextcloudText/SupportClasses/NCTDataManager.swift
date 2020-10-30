//
//  DataSaver.swift
//  NextcloudText
//
//  Created by Collin James on 10/27/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import UIKit
import CoreData

class NCTDataManager {
    private func getContext() -> NSManagedObjectContext {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        
        // get the container
        let myContainer = sceneDelegate.persistentContainer
        
        // get a context
        return myContainer.viewContext
    }
    
    func saveCreds(for name: String, at server: String) -> Bool{
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        
        // get the container
        let myContainer = sceneDelegate.persistentContainer
        
        // get a context
        let managedContext = myContainer.viewContext
        
        // get an entity in the context
        let entity =
            NSEntityDescription.entity(forEntityName: "AppLoginUser",
                                       in: managedContext)!
        
        // get a managed object from the entity
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // set the values in the managed object
        user.setValue(name, forKeyPath: "loginName")
        user.setValue(server, forKeyPath: "server")
        
        // do the actual saving
        myContainer.saveContext(with: managedContext)
        
        return true
    }
    
    /**
     Raise an alert to the user
     - Parameters:
        - entity: the string representing the entity name
        - returnFaults: set to false to return all objects, not faults
     */
    func fetchData(ofType entity: String, _ returnFaults: Bool = true) -> [NSManagedObject]? {
        
        // get a context
        let managedContext = self.getContext()
        
        // get a fetch request
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = returnFaults
        // do the actual fetching
        do {
            let data = try managedContext.fetch(fetchRequest)
            return data
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func deleteData(for object: NSManagedObject) -> Bool {
        
        // get a context
        let managedContext = self.getContext()
        
        managedContext.delete(object)

        // do the actual deleting
        do {
            managedContext.delete(object)
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
        
    }
    
    func deleteAll(ofType entity: String) -> Bool {
        guard var objects = self.fetchData(ofType: entity) else { return false }
        while objects.count > 0 {
            let object = objects.last!
            guard self.deleteData(for: object) else {
                return false
            }
            objects = self.fetchData(ofType: entity, false)!
        }
        return true
    }

    func saveTestData(for testString: String) -> Bool {
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        
        // get the container
        let myContainer = sceneDelegate.persistentContainer
        
        // get a context
        let managedContext = myContainer.viewContext
        
        // get an entity in the context
        let entity =
            NSEntityDescription.entity(forEntityName: "TestData",
                                       in: managedContext)!
        
        // get a managed object from the entity
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // set the values in the managed object
        user.setValue(testString, forKeyPath: "testString")
        
        // do the actual saving
        myContainer.saveContext(with: managedContext)
        
        return true
    }
}
