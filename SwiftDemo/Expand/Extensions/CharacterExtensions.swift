//
//  CharacterExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Character {

    /// Check if character is emoji.
    var isEmoji: Bool {
        let scalarValue = String(self).unicodeScalars.first!.value
        switch scalarValue {
        case 0x3030, 0x00AE, 0x00A9,// Special Characters
        0x1D000...0x1F77F, // Emoticons
        0x2100...0x27BF, // Misc symbols and Dingbats
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default:
            return false
        }
    }

    /// Check if character is number.
    var isNumber: Bool {
        return Int(String(self)) != nil
    }

    /// Check if character is a letter.
    var isLetter: Bool {
        return String(self).hasLetters
    }

    /// Check if character is uppercased.
    var isUppercased: Bool {
        return String(self) == String(self).uppercased()
    }

    /// Check if character is lowercased.
    var isLowercased: Bool {
        return String(self) == String(self).lowercased()
    }

    /// Check if character is white space.
    var isWhiteSpace: Bool {
        return String(self) == " "
    }

    /// Integer from character (if applicable).
    var int: Int? {
        return Int(String(self))
    }

    /// String from character.
    var string: String {
        return String(self)
    }

    /// Return the character lowercased.
    var lowercased: Character {
        return String(self).lowercased().characters.first!
    }

    /// Return the character uppercased.
    var uppercased: Character {
        return String(self).uppercased().characters.first!
    }

}

// MARK: - Operators
public extension Character {

    /// Repeat character multiple times.
    ///
    /// - Parameters:
    ///   - lhs: character to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: string with character repeated n times.
    static func * (lhs: Character, rhs: Int) -> String {
        guard rhs > 0 else {
            return ""
        }
        return String(repeating: String(lhs), count: rhs)
    }

    /// Repeat character multiple times.
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: character to repeat.
    /// - Returns: string with character repeated n times.
    static func * (lhs: Int, rhs: Character) -> String {
        guard lhs > 0 else {
            return ""
        }
        return String(repeating: String(rhs), count: lhs)
    }
    
}
