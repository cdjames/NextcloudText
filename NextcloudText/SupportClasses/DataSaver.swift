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
