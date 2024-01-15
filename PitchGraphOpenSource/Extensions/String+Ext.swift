//
//  String+Ext.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

extension String {
    public func splitBefore(separator: (Character) -> Bool) -> [String] {
        var result: [String] = []
        var currentWord: String = ""
        for character in self {
            if separator(character) && !currentWord.isEmpty {
                result.append(currentWord)
                currentWord = ""
            }
            currentWord.append(character)
        }
        if !currentWord.isEmpty {
            result.append(currentWord)
        }
        return result
    }
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension String {
    /// Localizes the string.
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    /// Localizes the string with a comment for translators.
    ///
    /// - Parameter comment: A comment that describes the purpose of the string to translators.
    public func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
