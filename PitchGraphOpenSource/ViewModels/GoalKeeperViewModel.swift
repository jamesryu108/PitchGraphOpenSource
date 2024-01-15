//
//  GoalKeeperViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

/// ViewModel responsible for managing and displaying goalkeeper attributes in a football app.
final class GoalKeeperViewModel {
    
    // MARK: - Properties

    /// Attributes for the first player. Only modifiable within this class.
    private(set) var goalkeeperAttributesForPlayer1: [GoalKeeperAttribute] = []

    /// Attributes for the second player. Only modifiable within this class and optional.
    private(set) var goalkeeperAttributesForPlayer2: [GoalKeeperAttribute]?

    /// Manager for UserDefaults, allowing for persistence of user settings.
    private let userDefaults: UserDefaultsManaging

    /// A set of AnyCancellable to store subscriptions.
    private var cancellables: Set<AnyCancellable> = []

    /// The currently selected option index in the UI. Published to allow observation by views.
    @Published private(set) var selectedOptionIndex: IndexPath?
    
    /// Data of the first player.
    private(set) var player1: PlayerData

    /// Data of the second player, optional.
    private(set) var player2: PlayerData?
    
    // MARK: - Initializer

    /// Initializes a new ViewModel with user defaults manager and player data.
    /// - Parameters:
    ///   - userDefaults: The UserDefaultsManaging instance for managing user defaults.
    ///   - player1: Data of the first player.
    ///   - player2: Data of the second player, optional.
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
    /// Private method to check and load the color theme preference from UserDefaults.
    func checkColorTheme() {
        Task {
            selectedOptionIndex = await userDefaults.loadSelectedOptionIndex(for: .selectedOptionIndex) ?? IndexPath(row: 0, section: 0)
        }
    }
    
    /// Processes and updates the goalkeeper attributes for both players.
    func processData() {
        goalkeeperAttributesForPlayer1 = player1.getAllGoalKeeperAttributes()
        if let player2 {
            goalkeeperAttributesForPlayer2 = player2.getAllGoalKeeperAttributes()
        }
    }
}

// MARK: - GoalKeeperConfigurable Conformance
extension GoalKeeperViewModel: GoalKeeperConfigurable {
 
    /// Subscribes to changes in the `selectedOptionIndex` property and triggers a handler.
    /// - Parameter handler: A closure that is called with the new value of `selectedOptionIndex`.
    func subscribeToSelectedOptionIndexChanges(
        handler: @escaping (IndexPath?) -> Void) {
        $selectedOptionIndex
            .sink(receiveValue: handler)
            .store(in: &cancellables)
    }
}
