//
//  UITextViewExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 9/28/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit


// MARK: - Methods
public extension UITextView {
	
	/// SwifterSwift: Clear text.
	public func clear() {
		text = ""
		attributedText = NSAttributedString(string: "")
	}
	
	/// SwifterSwift: Scroll to the bottom of text view
	public func scrollToBottom() {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
		scrollRangeToVisible(range)
	}
	
	/// SwifterSwift: Scroll to the top of text view
	public func scrollToTop() {
		let range = NSRange(location: 0, length: 1)
		scrollRangeToVisible(range)
	}
	
}
#endif
