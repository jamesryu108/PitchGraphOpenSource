//
//  SearchParameter.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `SearchParameter` encapsulates the criteria used for searching items.
/// It includes ranges for age, current ability, potential ability, and a sorting option.
public struct SearchParameter {
    /// The age range for the search. Represented as a closed range (inclusive).
    public let ageRange: ClosedRange<Int>
    
    /// The ability range for the search. Represented as a closed range (inclusive).
    public let abilityRange: ClosedRange<Int>
    
    /// The potential range for the search. Represented as a closed range (inclusive).
    public let potentialRange: ClosedRange<Int>
    
    /// The sorting option to be used for the search results.
    public let sortOption: SortOption
    
    // The default memberwise initializer is automatically provided by Swift.
    public init(ageRange: ClosedRange<Int>, abilityRange: ClosedRange<Int>, potentialRange: ClosedRange<Int>, sortOption: SortOption) {
        self.ageRange = ageRange
        self.abilityRange = abilityRange
        self.potentialRange = potentialRange
        self.sortOption = sortOption
    }
}
