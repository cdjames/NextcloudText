//
//  String+Extensions.swift
//  NextcloudText
//
//  Created by Collin James on 10/14/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation

extension String {
    // https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
    var isValidURL: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
    var isNotEmpty: Bool {
        get {
            return self.count != 0
        }
    }
}
