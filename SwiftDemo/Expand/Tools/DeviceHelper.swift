//
//  DeviceHelper.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

struct Device {
    /// Current device battery level
    static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }

    /// Check if device is iPhone.
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// Check if device is iPad.
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// Check if application is running on simulator (read-only).
    static var isSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            return true
        #else
            return false
        #endif
    }

    /// Current system version
    static var systemVersion: Float {
        return Float(UIDevice.current.systemVersion) ?? 0
    }

    /// 判断当前系统版本是不是高于8.0
    static var isIOS8: Bool {
        return systemVersion >= 8.0
    }

    /// 获取已用内存
    static func report_memory() {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            print("Memory used in bytes: \(taskInfo.resident_size)")
        } else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }
    }

    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
}
