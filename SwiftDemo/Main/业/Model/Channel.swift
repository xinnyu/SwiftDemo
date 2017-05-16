//
//  File.swift
//  SwiftDemo
//
//  Created by panxinyu on 15/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation
import ObjectMapper

struct Channel: Mappable {
    var name: String!
    var id: Int!
    var cover: String?

    var coverUrl: URL? {
        return URL(string: cover ?? "")
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        cover <- map["cover"]
    }

    init?(map: Map) {

    }
}
