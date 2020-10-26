//
//  Constants.swift
//  NextcloudText
//
//  Created by Collin James on 10/18/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation

//MARK: Constants
let HTTP = "http"
let HTTPS = "https"
let LOGIN_PREDICATE = "/index.php/login/v2"
let APP_PSSWD_PREDICATE = "/ocs/v2.php/core/apppassword"
let FWD_SLASH = "/"
let EMPTY = ""
let ALRT_BTN_TXT = "OK"
let POLL_MS = 1000
let POLL_SEC = 1
//let POLL_INTERVAL = DispatchTime.now() + DispatchTimeInterval.milliseconds(POLL_MS)
let POLL_INTERVAL = DispatchTime.now() + DispatchTimeInterval.seconds(POLL_SEC)
