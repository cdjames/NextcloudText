//
//  AppLoginUser+CoreDataProperties.swift
//  NextcloudText
//
//  Created by Collin James on 10/26/20.
//  Copyright © 2020 Collin James. All rights reserved.
//
//

import Foundation
import CoreData


extension AppLoginUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppLoginUser> {
        return NSFetchRequest<AppLoginUser>(entityName: "AppLoginUser")
    }

    @NSManaged public var loginName: String?
    @NSManaged public var server: String?

}
