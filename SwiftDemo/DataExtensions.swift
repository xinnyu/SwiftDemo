//
//  DataExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import UIKit

public extension Data {

    /// 从Data获取NSAttributedString
    public var attributedString: NSAttributedString? {
        return try? NSAttributedString(data: self, options: [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }

    /// 从Data获取String
    public func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
}
