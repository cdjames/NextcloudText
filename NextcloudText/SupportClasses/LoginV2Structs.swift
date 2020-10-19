//
//  LoginV2Structs.swift
//  NextcloudText
//
//  Created by Collin James on 10/18/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation
import os.log

/**
add summary here
 */
struct PollLogin: Codable {
    struct TokenEndpoint: Codable {
        var token: String
        var endpoint: URL
    }
    var poll: TokenEndpoint?
    var login: URL?
    
    init?(from data: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(PollLogin.self, from: data)
//        } catch DecodingError.dataCorrupted { // enable for debugging
//            return
        } catch let DecodingError.keyNotFound(key, context) {
            os_log(.debug, "keyNotFound: %s", key.debugDescription)
            os_log(.debug, "context: %s", context.debugDescription)
            return
//        } catch DecodingError.typeMismatch {
//            return
//        } catch DecodingError.valueNotFound {
//            return
        } catch {
            return
        }
    }
}

struct AppLoginCreds: Codable {
    var server: URL
    var loginName: String
    var password: String
}
