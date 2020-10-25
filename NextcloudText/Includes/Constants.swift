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
let FWD_SLASH = "/"
let EMPTY = ""
let ALRT_BTN_TXT = "OK"
let POLL_INTERVAL = DispatchTime.now() + DispatchTimeInterval.milliseconds(500)

typealias PollCbk = ((PollLogin?) -> Void)
typealias VoidVoidCbk = (() -> Void)
