//
//  ScreenHelper.swift
//  SwiftDemo
//
//  Created by panxinyu on 14/05/2017.
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
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// Screen width
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
}
