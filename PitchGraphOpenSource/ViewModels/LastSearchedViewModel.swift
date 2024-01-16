//
//  LastSearchedViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-16.
//

import Foundation

/// `LastSearchViewModel` is responsible for managing and retrieving data for the last searched player.
public final class LastSearchViewModel {

    
    public var players: [LastSearchedPlayerInfo] = []
    
    // MARK: - Published Property
    @Published public private(set) var playerData: PlayerData? // Holds the data of the last searched player.

    // MARK: - Core Data Manager
    private let coreDataManager: CoreDataManaging
    
    // MARK: - Intializers
    
    public init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Fetch Player Data Method
    /// Asynchronously fetches data for a player based on their unique ID and updates `playerData`.
    /// - Parameter id: The unique identifier of the player.
    public func callForPlayer(id: String) async {
        // Construct the URL string for fetching individual player data.
        let finalString = NetworkCaller.baseURLPlayerSearch + "/" + id
        do {
            // Attempt to fetch the data and store it in `playerData`.
            let finalData: PlayerData = try await NetworkCaller.shared.fetchData(from: finalString)
            playerData = finalData
        } catch {
            // Handle errors by printing the error description.
            debugPrint("failed: \(error.localizedDescription)")
        }
    }
    
    public func fetchAllPlayers() -> [LastSearchedPlayerInfo] {
        return coreDataManager.fetchAll()
    }
    
    public func saveInLastSavedList(playerInfo: LastSearchedPlayerInfo) {
        coreDataManager.savePlayerInfo(playerInfo)
    }
    
    public func deleteAllPlayerInfo() {
        coreDataManager.deleteAll(entityType: .lastSearched)
    }
}
