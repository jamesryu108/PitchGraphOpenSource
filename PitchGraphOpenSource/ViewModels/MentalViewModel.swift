//
//  MentalViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

final class MentalViewModel {
    
    /// Attributes for the first player. Only modifiable within this class.
    private(set) var mentalAttributesForPlayer1: [MentalAttribute] = []
    /// Attributes for the second player. Only modifiable within this class.
    private(set) var mentalAttributesForPlayer2: [MentalAttribute]?
    
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
    
    /// Private method to check and load the color theme preference from UserDefaults.
    func checkColorTheme() {
        Task {
            selectedOptionIndex = await userDefaults.loadSelectedOptionIndex(for: .selectedOptionIndex) ?? IndexPath(row: 0, section: 0)
        }
    }
    
    /// Processes and updates the mental attributes for both players.
    func processData() {
        mentalAttributesForPlayer1 = player1.getAllMentalAttributes()
        if let player2 {
            mentalAttributesForPlayer2 = player2.getAllMentalAttributes()
        }
    }
}

extension MentalViewModel: MentalConfigurable {
    /// Subscribes to changes in the `selectedOptionIndex` property and triggers a handler.
    /// - Parameter handler: A closure that is called with the new value of `selectedOptionIndex`.
    func subscribeToSelectedOptionIndexChanges(
        handler: @escaping (IndexPath?) -> Void) {
            $selectedOptionIndex
                .sink(receiveValue: handler)
                .store(in: &cancellables)
        }
}
