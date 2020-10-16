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
}

extension UrlBuilder {
    static func create(withScheme s: String, hostedBy h: String, atPath p: String) -> UrlBuilder {
        return UrlBuilder(
            scheme: s,
            host: h,
            path: p
        )
    }
}

extension UrlBuilder {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        return components.url
    }
}
