//
//  SortOption.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `SortOption` defines various criteria by which a collection of items can be sorted.
/// It provides options for sorting based on different attributes like age and  current/potential ability,
/// both in ascending and descending order. It is set to 'nothing' as default until users choose to set this value.
public enum SortOption: String, Codable, CaseIterable {
    
    /// Sort items by age in ascending order.
    case ageAscending = "age (ascending)"
    
    /// Sort items by age in descending order.
    case ageDescending = "age (descending)"
    
    /// Sort items by current ability in ascending order.
    case currentAbilityAscending = "current ability (ascending)"
    
    /// Sort items by current ability in descending order.
    case currentAbilityDescending = "current ability (descending)"
    
    /// Sort items by potential ability in ascending order.
    case potentialAbilityAscending = "potential ability (ascending)"
    
    /// Sort items by potential ability in descending order.
    case potentialAbilityDescending = "potential ability (descending)"
    
    /// Represents a state where no sorting is applied.
    case nothing = "nothing"
    
    /// Returns a localized string representation of the sort option.
    /// Useful for UI elements that display sorting criteria in different languages.
    public var localizedString: String {
        NSLocalizedString(rawValue, comment: "")
    }
    
    // Use Codable to handle conversion from/to String
    static public func from(stringValue: String) -> SortOption? {
        return self.allCases.first(where: { $0.rawValue == stringValue })
    }
}
