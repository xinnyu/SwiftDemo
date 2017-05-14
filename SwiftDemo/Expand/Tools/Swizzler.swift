//
//  Swizzler.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

/// 方法交换
public struct Swizzler {

    public enum Kind {
        case instance
        case `class`
    }


    /// 交换两个方法
    ///
    /// - Parameters:
    ///   - method: 需要交换的方法
    ///   - cls: 类
    ///   - prefix: 交换后方法的前缀，默认 "swizzled"
    ///   - kind: 需要交换方法的种类 默认实例方法 .instance ， .class 类方法
    public static func swizzle(_ method: String, cls: AnyClass!, prefix: String = "swizzled", kind: Kind = .instance) {
        let originalSelector = Selector(method)
        let swizzledSelector = Selector("\(prefix)_\(method)")

        let originalMethod = kind == .instance
            ? class_getInstanceMethod(cls, originalSelector)
            : class_getClassMethod(cls, originalSelector)

        let swizzledMethod = kind == .instance
            ? class_getInstanceMethod(cls, swizzledSelector)
            : class_getClassMethod(cls, swizzledSelector)

        let didAddMethod = class_addMethod(cls, originalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
