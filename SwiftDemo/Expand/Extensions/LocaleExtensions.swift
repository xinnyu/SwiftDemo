//
//  LocaleExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Locale {

    /// UNIX 格式化时间
    public static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }

    public static var china: Locale {
        return Locale(identifier: "zh")
    }
    
}
