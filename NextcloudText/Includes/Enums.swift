//
//  Enums.swift
//  NextcloudText
//
//  Created by Collin James on 10/25/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
