//
//  API.swift
//  SwiftDemo
//
//  Created by panxinyu on 15/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

protocol API {
    var host: String { get }
    var path: String { get }
    var url: String? { get }
    var header: [String:Any]? { get }
    var parameter: [String:Any]? { get }
}

extension API {
    var url: String? {
        return host + path
    }
}







