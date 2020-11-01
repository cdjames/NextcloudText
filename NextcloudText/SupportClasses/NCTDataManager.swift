//
//  DataSaver.swift
//  NextcloudText
//
//  Created by Collin James on 10/27/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import UIKit
import CoreData
import os.log

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
    
    func searchKeychain(for keys: Any) -> Any? {
        var query: [String: Any]
        // assemble the query
        switch keys {
        case is AppLoginCreds:
            let data = keys as! AppLoginCreds
            query = [kSecClass as String: kSecClassInternetPassword,
                     kSecAttrAccount as String: data.loginName!,
                     kSecMatchLimit as String: kSecMatchLimitOne,
                     kSecReturnAttributes as String: true,
                     kSecReturnData as String: true]
        default:
            os_log(.debug, "NCTDataManager: no handler for searching this data type")
            return nil
        }
        
        // do the actual searching
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            os_log(.debug, "NCTDataManager: error searching keychain: %s", KeychainError.noPassword.localizedDescription)
            return nil
        }
        guard status == errSecSuccess else {
            os_log(.debug, "NCTDataManager: error searching keychain: %s", KeychainError.unhandledError(status: status).localizedDescription)
            return nil
        }
        
        // extract the data
        switch keys {
        case is AppLoginCreds:
            guard let existingItem = item as? [String : Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: String.Encoding.utf8),
                let account = existingItem[kSecAttrAccount as String] as? String,
                let server = existingItem[kSecAttrServer as String] as? String
            else {
                os_log(.debug, "NCTDataManager: %s", KeychainError.unexpectedPasswordData.localizedDescription)
                return nil
            }
            let svr = URL(string: server)!
            let creds = AppLoginCreds(server: svr, user: account, password: password)
            return creds as Any
        default:
            os_log(.debug, "NCTDataManager: no handler for extracting this data type")
            return nil
        }
    }
    
    func saveToKeychain(_ keys: Any) -> Bool {
        var query: [String: Any]
        
        switch keys {
        case is AppLoginCreds:
            let data = keys as! AppLoginCreds
            let name = data.loginName!
            let svr = data.server!.absoluteString
            let pwd = data.appPassword!.data(using: .utf8)
            query = [kSecClass as String: kSecClassInternetPassword,
                     kSecAttrAccount as String: name,
                     kSecAttrServer as String: svr,
                     kSecValueData as String: pwd as Any]
        default:
            os_log(.debug, "NCTDataManager: no handler for this data type")
            return false
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            os_log(.debug, "NCTDataManager: error saving to keychain: %s", KeychainError.unhandledError(status: status).localizedDescription)
            return false
        }
        return true
    }
    
    func deleteFromKeychain(_ keys: Any) -> Bool {
        var query: [String: Any]
        
        switch keys {
        case is AppLoginCreds:
            let data = keys as! AppLoginCreds
            query = [kSecClass as String: kSecClassInternetPassword,
                     kSecAttrServer as String: data.server!.absoluteString]
        default:
            os_log(.debug, "NCTDataManager: no handler for this data type")
            return false
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            os_log(.debug, "NCTDataManager: error deleting from keychain: %s", KeychainError.unhandledError(status: status).localizedDescription)
            return false
        }

        return true
    }
}
