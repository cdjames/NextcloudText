//
//  UrlBuilder.swift
//  NextcloudText
//
//  Created by Collin James on 10/14/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import struct Foundation.URL
import struct Foundation.URLComponents

// using ideas from https://www.swiftbysundell.com/articles/constructing-urls-in-swift/

struct UrlBuilder {
    let scheme: String
    let host: String
    let path: String
    var url: URL?
    var components: URLComponents
    
     /**
     custom init method
     - Parameters:
         - url:object containing the necessary url
    */
    init(with scheme: String, at host: String, opt path: String?) {
        self.scheme = scheme
        self.host = host
        self.path = path ?? ""
        
        components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.path.prepend(one: FWD_SLASH)

        url = components.url
    }
}

extension UrlBuilder {
    func getUrl() -> URL? {
        return self.url ?? nil
    }
}

//extension UrlBuilder {
//    // We still have to keep 'url' as an optional, since we're
//    // dealing with dynamic components that could be invalid.
//    var url: URL? {
//        var components = URLComponents()
//        components.scheme = self.scheme
//        components.host = self.host
//        components.path = self.path + LOGIN_PREDICATE
//        components.path.prepend(one: FWD_SLASH)
//
//        return components.url
//    }
//}
