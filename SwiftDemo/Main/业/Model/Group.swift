//
//  Group.swift
//  SwiftDemo
//
//  Created by panxinyu on 16/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation
import ObjectMapper

struct Group:Mappable {
    var chls: [Channel]!
    var group_id: Int!
    var group_name: String?

    mutating func mapping(map: Map) {
        chls <- map["chls"]
        group_id <- map["group_id"]
        group_name <- map["group_name"]
    }

    init?(map: Map) { }
}
