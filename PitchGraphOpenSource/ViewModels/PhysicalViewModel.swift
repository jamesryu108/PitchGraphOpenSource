//
//  PhysicalViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

/// ViewModel for managing and presenting physical attributes of players in a sports context.
final class PhysicalViewModel {
    
    // MARK: - Properties

    /// Physical attributes of the first player. Read-only outside the class.
    private(set) var physicalAttributesForPlayer1: [PhysicalAttribute] = []

    /// Physical attributes of the second player (optional). Read-only outside the class.
    private(set) var physicalAttributesForPlayer2: [PhysicalAttribute]?

    /// UserDefaults manager for handling user settings and preferences.
    private let userDefaults: UserDefaultsManaging

    /// Set of AnyCancellable for managing Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []

    /// The index of the currently selected option in the UI. Observable for UI updates.
    @Published private(set) var selectedOptionIndex: IndexPath?
    
    /// Data of the first player.
    private(set) var player1: PlayerData

    /// Data of the second player (optional).
    private(set) var player2: PlayerData?
    
    // MARK: - Initializer

    /// Initializes the ViewModel with user defaults and player data.
    /// - Parameters:
    ///   - userDefaults: An instance of a UserDefaultsManaging for managing user preferences.
    ///   - player1: Data for the first player.
    ///   - player2: Data for the second player (optional).
    init(
        userDefaults: UserDefaultsManaging,
        player1: PlayerData,
        player2: PlayerData? = nil
    ) {
        self.userDefaults = userDefaults
        self.player1 = player1
        self.player2 = player2
        checkColorTheme()
    }
    
    // MARK: - Methods

    /// Checks and loads the color theme preference from UserDefaults.
    func checkColorTheme() {
        Task {
            selectedOptionIndex = await userDefaults.loadSelectedOptionIndex(for: .selectedOptionIndex) ?? IndexPath(row: 0, section: 0)
        }
    }
    
    /// Processes and updates the physical attributes for both players.
    func processData() {
        physicalAttributesForPlayer1 = player1.getAllPhysicalAttributes()
        if let player2 = player2 {
            physicalAttributesForPlayer2 = player2.getAllPhysicalAttributes()
        }
    }
}

// MARK: - PhysicalConfigurable Conformance

extension PhysicalViewModel: PhysicalConfigurable {
 
    /// Subscribes to changes in the selected option index and triggers a handler.
    /// - Parameter handler: A closure that is called with the new value of the selectedOptionIndex.
    func subscribeToSelectedOptionIndexChanges(
        handler: @escaping (IndexPath?) -> Void) {
        $selectedOptionIndex
            .sink(receiveValue: handler)
            .store(in: &cancellables)
    }
}
