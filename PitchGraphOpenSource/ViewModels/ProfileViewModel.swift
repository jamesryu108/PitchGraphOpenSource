//
//  ProfileViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `ProfileViewModel` is a class responsible for managing and presenting player-related information, specifically focusing on reputation and various player attributes.
public final class ProfileViewModel {
    
    // MARK: - Constants
    private enum ReputationThreshold {
        static let regional = 2_500
        static let national = 5_250
        static let continental = 7_500
        static let worldwide = 10_000
    }
    
    // MARK: - Initializers
    public init() {}
    
    // MARK: - Reputation Method
    /// Determines the player's reputation level based on a numerical value.
    public func showReputation(reputationValue: Int) -> String {
        switch reputationValue {
        case 0..<ReputationThreshold.regional:
            return "Regional".localized
        case ReputationThreshold.regional..<ReputationThreshold.national:
            return "National".localized
        case ReputationThreshold.national..<ReputationThreshold.continental:
            return "Continental".localized
        case ReputationThreshold.continental...ReputationThreshold.worldwide:
            return "Worldwide".localized
        default:
            return "Unknown".localized // Handling for unknown cases.
        }
    }
    
    // MARK: - Player Attribute Creation Method
    /// Creates an array of `PlayerAttribute` objects representing different aspects of a player's data.
    /// - Parameter playerData: A `PlayerData` object containing various details about the player.
    /// - Returns: An array of `PlayerAttribute` objects.
    func createPlayerAttribute(
        playerData: PlayerData
    ) -> [PlayerAttribute] {
        return [
            PlayerAttribute(
                title: "Age",
                value: playerData.age ?? "N/A",
                unit: "years-old"
            ), // Player's age.
            PlayerAttribute(
                title: "Asking",
                value: playerData.askingPrice ?? "N/A",
                unit: "Transfer fee"
            ), // Player's asking price.
            PlayerAttribute(
                title: "Club",
                value: playerData.club ?? "N/A",
                unit: "His day job"
            ), // Player's current club.
            PlayerAttribute(
                title: "Personality".localized,
                value: playerData.personality ?? "N/A",
                unit: "Is he nice or not?".localized
            ), // Player's personality.
            PlayerAttribute(
                title: "Reputation".localized,
                value: showReputation(
                    reputationValue: playerData.reputation ?? 0
                ),
                unit: "Do you know him?".localized
            ), // Player's reputation.
            PlayerAttribute(
                title: "Ends".localized,
                value: "\(playerData.contractLength ?? "")",
                unit: "Last day".localized
            ) // Contract end date.
        ]
    }
}
