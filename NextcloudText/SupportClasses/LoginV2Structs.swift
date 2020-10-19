//
//  LoginV2Structs.swift
//  NextcloudText
//
//  Created by Collin James on 10/18/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation

struct PollLogin: Codable {
    struct TokenEndpoint: Codable {
        var token: String
        var endpoint: URL
    }
    var poll: TokenEndpoint
    var login: URL
}

struct AppLoginCreds: Codable {
    var server: URL
    var loginName: String
    var password: String
}

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}
