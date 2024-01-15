//
//  StatsViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import Foundation

// MARK: - Protocol Definition
/// Protocol to configure statistics.
protocol StatsConfigurable {
    var playerData: PlayerData { get }
    var playerData2: PlayerData? { get }
    func updateSelectedSegment(index: Int)
}

// MARK: - ViewModel Implementation
/// ViewModel for player statistics.
public final class StatsViewModel: StatsConfigurable {
    
    // MARK: Properties
    public let playerData: PlayerData
    public let playerData2: PlayerData?
    public let statsType: [String] = [
        "Technical",
        "Mental",
        "Physical",
        "Goalkeeping",
        "Hidden"
    ]
    public let appType: StatsMode
    @Published public var selectedIndex: Int = 0
    @Published public var titleText: String = ""

    // MARK: Combine cancellables
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initializers
    /// Initializes a new ViewModel with player data.
    public init(
        playerData: PlayerData,
        playerData2: PlayerData? = nil,
        appType: StatsMode
    ) {
        self.playerData = playerData
        self.playerData2 = playerData2
        self.appType = appType
        setupBindings()
    }

    // MARK: Private Methods
    /// Sets up bindings for the ViewModel.
    private func setupBindings() {
        $selectedIndex
            .map { [weak self] index -> String in
                guard let self = self, let playerName = self.playerData.name else {
                    return "Unknown Player Stats"
                }
                let isGoalKeeper = playerData.positions?.contains("GK") ?? false && index == 0
                return "\(appType != .compareMode ? playerName : "") \(isGoalKeeper ? "GoalKeeping".localized : self.statsType[index].localized) \("Stats".localized)"
            }
            .assign(to: \.titleText, on: self)
            .store(in: &cancellables)
    }

    // MARK: Public Methods
    /// Updates the selected segment index.
    public func updateSelectedSegment(index: Int) {
        selectedIndex = index
    }
}
