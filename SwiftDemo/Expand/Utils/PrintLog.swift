//
//  PrintLog.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
        print("Log:\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

func printError<T>(_ message: T,
                   file: String = #file,
                   method: String = #function,
                   line: Int = #line) {
    #if DEBUG
        print("‼️Error:\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
