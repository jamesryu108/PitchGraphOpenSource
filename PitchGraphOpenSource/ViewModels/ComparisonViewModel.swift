//
//  ComparisonViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `ComparisonViewModel` is a class responsible for fetching and storing player data for comparison. It uses network calls to retrieve data about individual players or similar players.
public final class ComparisonViewModel {

    // MARK: - Published Properties
    @Published public private(set) var playerData: [PlayerData]? // Stores data for individual players.

    var player1: PlayerData?
    
    /// Data for the second player.
    var player2: PlayerData?
    
    let userDefaultsManager: UserDefaultsManaging
    
    // MARK: - Initializers
    
    public init(
        playerData: [PlayerData]? = nil,
        userDefaultsManager: UserDefaultsManaging
    ) {
        self.playerData = playerData
        self.userDefaultsManager = userDefaultsManager
        
        Task {
            await getPlayers()
        }
    }
    
    func getPlayers() async {
        Task {
            self.player1 = try? await UserDefaultsManager.shared.load(for: UserDefaultsKey.playerData1, as: PlayerData.self)
            
            self.player2 = try? await UserDefaultsManager.shared.load(for: UserDefaultsKey.playerData2, as: PlayerData.self)
            print("^^^^ player1: \(self.player1)")
        }
    }
    
    // MARK: - Call for Player Method
    /// Asynchronously fetches data for a single player based on their name and updates `playerData`.
    /// - Parameter name: The name of the player.
    public func callForPlayer(name: String, isDebug: Bool) async {
        if isDebug {
            await fetchMockData()
        } else {
            await fetchPlayerData(withName: name)
        }
    }
    
    /// Fetches mock data for debugging purposes.
    private func fetchMockData() async {
        // Define your mock data here
        let mockPlayerData: [PlayerData] = [
            PlayerData.messiPlayerData,
            PlayerData.onanaPlayerData,
            PlayerData.sonPlayerData,
            PlayerData.donnaRummaPlayerData,
            PlayerData.kimPlayerData
        ]

        self.playerData = mockPlayerData
    }
    
    /// Fetches real player data from API.
    @MainActor
    private func fetchPlayerData(withName name: String) async {
        let finalString = NetworkCaller.baseURLPlayerSearch + "?name=" + name
        do {
            let finalData: [PlayerData] = try await NetworkCaller.shared.fetchData(from: finalString)
                playerData = finalData
        } catch {
            debugPrint("Failed to fetch player data: \(error.localizedDescription)")
        }
    }
}
