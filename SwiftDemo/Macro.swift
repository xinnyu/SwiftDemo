//
//  Macro.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

/// Screen size
struct Screen {
    /// StatusBar height
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// Screen height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// Screen width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}

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
}
