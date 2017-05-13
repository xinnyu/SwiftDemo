//
//  BoolExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Bool {

    /// 真返回1，假返回0
    public var int: Int {
        return self ? 1 : 0
    }

    /// 真返回"true"，假返回"false"
    public var string: String {
        return description
    }
}
