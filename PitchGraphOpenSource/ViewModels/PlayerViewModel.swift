//
//  PlayerViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public final class PlayerViewModel {
    
    @Published public var playerData: PlayerData?
    
    private let coreDataManager: CoreDataManaging
    
    public init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }
    
    public func givePlayerData(playerData: PlayerData?) {
        self.playerData = playerData
    }
    
    public func loadPlayerInfo() -> PlayerInfo? {
        guard let playerId = playerData?.playerId else {
            return nil
        }
        return coreDataManager.loadPlayerInfo(playerId: playerId)
    }
    
    public func isPlayerFavorited(playerId: String) -> Bool {
        guard let playerData, let playerID = playerData.playerId else {
            return false
        }
        return coreDataManager.isPlayerFavorited(playerId: playerID)
    }
    
    public func deletePlayerInfo(playerId: String) {
        coreDataManager.delete(entityType: .player, playerId: playerId)
    }
    
    // Generic save method
    public func savePlayerInfo<T: Codable>(_ playerInfo: T) {
        if let playerInfo = playerInfo as? PlayerInfo {
            coreDataManager.savePlayerInfo(playerInfo)
        } else if let lastSearchedInfo = playerInfo as? LastSearchedPlayerInfo {
            coreDataManager.savePlayerInfo(lastSearchedInfo)
        }
    }
    
    public func manageLastSearchedPlayersAndUpdate(newPlayerInfo: LastSearchedPlayerInfo, isPro: Bool) {
        // Check if the number of entries exceeds the maximum
        if coreDataManager.exceededMaximumNumberOfEntries(isPro: isPro) {
            // Exceeds the limit, delete the oldest entry
            coreDataManager.deleteOldestLastSearched()
        }
        // Add the new data
        coreDataManager.savePlayerInfo(newPlayerInfo)
    }
}
