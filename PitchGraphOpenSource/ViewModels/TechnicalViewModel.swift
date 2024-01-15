//
//  TechnicalViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

/// ViewModel for managing and presenting technical attributes of players in a sports context.
final class TechnicalViewModel {
    
    // MARK: - Properties

    /// Technical attributes of the first player. Read-only outside the class.
    private(set) var technicalAttributesForPlayer1: [TechnicalAttribute] = []

    /// Technical attributes of the second player (optional). Read-only outside the class.
    private(set) var technicalAttributesForPlayer2: [TechnicalAttribute]?

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
    
    /// Processes and updates the technical attributes for both players.
    func processData() {
        technicalAttributesForPlayer1 = player1.getAllTechnicalAttributes()
        if let player2 = player2 {
            technicalAttributesForPlayer2 = player2.getAllTechnicalAttributes()
        }
    }
}

// MARK: - TechnicalConfigurable Conformance

extension TechnicalViewModel: TechnicalConfigurable {
 
    /// Subscribes to changes in the selected option index and triggers a handler.
    /// - Parameter handler: A closure that is called with the new value of the selectedOptionIndex.
    func subscribeToSelectedOptionIndexChanges(
        handler: @escaping (IndexPath?) -> Void) {
        $selectedOptionIndex
            .sink(receiveValue: handler)
            .store(in: &cancellables)
    }
}
