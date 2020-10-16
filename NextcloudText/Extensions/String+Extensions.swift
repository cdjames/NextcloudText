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
    var isValidFolderChar: Bool {
        get {
            // is the character one of the following:
            // A–Z, a–z, 0–9, -, ., _, ~, !, $, &, ', (, ), *, +, ,, ;, =, :, @, /
            let regEx = "(([\\w\\d\\.\\-_~/\\!\\$&'\\(\\)\\*\\+,;=:@]))?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
    var isNotEmpty: Bool {
        get {
            return self.count != 0
        }
    }
    
    // https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
    // lets you perform Python-like subscripting on strings
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    mutating func trimRight(all char: String) {
        while self[self.count-1] == char {
            self.removeLast()
        }
    }
}
