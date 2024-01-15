//
//  StatsSettingsViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

final class StatsSettingsViewModel {

    // MARK: - Properties
    let options: [Option] = [
        .option1,
        .option2,
        .option3,
        .option4
    ]
    
    private let userDefaults: UserDefaultsManaging
    private var cancellables: Set<AnyCancellable> = []
    
    var technicalAttributesForPlayer1: [TechnicalAttribute] = []
    var technicalAttributesForPlayer2: [TechnicalAttribute]?

    var player1: PlayerData
    
    @Published var selectedOptionIndex: IndexPath?
    
    init(
        userDefaults: UserDefaultsManaging,
        player1: PlayerData
    ) {
        self.userDefaults = userDefaults
        self.player1 = player1
    }
    
    func checkColorTheme() {
        Task {
            selectedOptionIndex = await userDefaults.loadSelectedOptionIndex(for: .selectedOptionIndex) ?? IndexPath(row: 0, section: 0)
        }
    }
}

extension StatsSettingsViewModel: TechnicalConfigurable {
    func processData() {
        technicalAttributesForPlayer1 = player1.getAllTechnicalAttributes()
    }

    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void) {
        $selectedOptionIndex
            .sink(receiveValue: handler)
            .store(in: &cancellables)
    }
}
