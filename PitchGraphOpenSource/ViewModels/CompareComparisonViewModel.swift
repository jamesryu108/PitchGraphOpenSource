//
//  CompareComparisonViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// Enum representing different comparison criteria.
enum ComparisonCriteria: String, CaseIterable {
    case name = "Name"
    case nationality = "Nationality"
    case currentAbility = "Current Ability"
    case potentialAbility = "Potential Ability"
    case primaryPosition = "Primary Position"
    case askingPrice = "Asking Price"
    case contractedUntil = "Contracted Until"
    case reputation = "Reputation"
    case club = "Club"
    case personality = "Personality"
}

/// `CompareComparisonViewModel` is an `ObservableObject` class responsible for generating comparison data between two players across various parameters.
public final class CompareComparisonViewModel {

    // MARK: - Initializer
    public init() {}
    
    // MARK: - Create Data Method
    /// Generates a list of `PlayerComparison` objects for comparing two players.
    /// - Parameters:
    ///   - player1: The first `PlayerData` object representing the first player.
    ///   - player2: The second `PlayerData` object representing the second player.
    /// - Returns: An array of `PlayerComparison` objects representing the comparison between the two players across various parameters.
    public func createData(
        player1: PlayerData,
        player2: PlayerData
    ) -> [PlayerComparison] {
        return ComparisonCriteria.allCases.map { criteria in
            PlayerComparison(
                parameter: criteria.rawValue.localized,
                leftValue: value(for: criteria, player: player1),
                rightValue: value(for: criteria, player: player2)
            )
        }
    }
    
    /// Helper function to extract player value based on criteria.
    private func value(
        for criteria: ComparisonCriteria,
        player: PlayerData
    ) -> String {
        switch criteria {
        case .name:
            return player.name ?? ""
        case .nationality:
            return player.nationalities?.first ?? ""
        case .currentAbility:
            return "\(player.currentAbility ?? 0)"
        case .potentialAbility:
            return "\(player.potentialAbility ?? "0")"
        case .primaryPosition:
            return player.positions?.first ?? ""
        case .askingPrice:
            return player.askingPrice ?? "N/A"
        case .contractedUntil:
            return player.contractLength ?? "N/A"
        case .reputation:
            return "\(player.reputation ?? 0)"
        case .club:
            return player.club ?? "N/A"
        case .personality:
            return player.personality ?? "N/A"
        }
    }
}
