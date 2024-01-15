//
//  CoreDataManager.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import CoreData
import Foundation

// Enum to represent different entity types
public enum EntityType {
    case player
    case lastSearched
}

public protocol CoreDataManaging {
    func savePlayerInfo<T: Codable>(_ playerInfo: T)
    func loadPlayerInfo(playerId: String) -> PlayerInfo?
    func isPlayerFavorited(playerId: String) -> Bool
    func fetchAll<T: Codable>() -> [T]
    func deleteAll(entityType: EntityType)
    func delete(entityType: EntityType, playerId: String)
    func exceededMaximumNumberOfEntries(isPro: Bool) -> Bool
    func deleteOldestLastSearched()
}

/// `FavouriteViewModel` is an `ObservableObject` class focused on managing and retrieving data for a specific player, typically a favorite player as identified by their unique ID.
public final class FavouriteViewModel {
    
    public var players: [PlayerInfo] = []

    // MARK: - Published Property
    @Published public var playerData: PlayerData? // Holds the data of the favorite player.

    // MARK: - CoreData Manager

    let coreDataManager: CoreDataManaging
    
    // MARK: - Intializers
    
    public init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Core Data stuff
    
    public func fetchAllPlayers() {
        players = coreDataManager.fetchAll()
    }
    
    public func deleteAllPlayerInfo() {
        coreDataManager.deleteAll(entityType: .player)
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
            print("failed: \(error.localizedDescription)")
        }
    }
}


final class CoreDataManager: CoreDataManaging {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "PitchGraph")
        
        // turn on persistent history tracking
        // https://developer.apple.com/documentation/coredata/consuming_relevant_store_changes
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber,
                               forKey: NSPersistentHistoryTrackingKey)
        
        // turn on remote change notifications
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description?.setOption(true as NSNumber,
                                   forKey: remoteChangeKey)
        
        // this will make background updates from iCloud available to the context.
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // call this LAST, after the persistentStoreDescriptions configuration.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private init() {}
    
    func savePlayerInfo<T: Codable>(_ playerInfo: T) {
        let context = persistentContainer.viewContext
        
        if let playerInfo = playerInfo as? PlayerInfo {
            let entity = PlayerEntity(context: context)
            entity.playerId = playerInfo.playerId
            entity.name = playerInfo.name
            entity.nationality = playerInfo.nationality
            entity.club = playerInfo.club
            // Additional logic for PlayerEntity
        } else if let lastSearchedInfo = playerInfo as? LastSearchedPlayerInfo {
            let entity = LastSearchedEntity(context: context)
            entity.playerId = lastSearchedInfo.playerId
            entity.name = lastSearchedInfo.name
            entity.nationality = lastSearchedInfo.nationality
            entity.club = lastSearchedInfo.club
            entity.lastSearched = lastSearchedInfo.lastSearched
            // Additional logic for LastSearchedEntity
        }
        
        do {
            try context.save()
            NotificationCenter.default.post(name: .NSPersistentStoreRemoteChange, object: nil)
        } catch {
            print("Failed to save player info: \(error)")
        }
    }
    
    // Generic function to load player information
    func loadPlayerInfo<T: Codable>(playerId: String) -> T? {
        let context = persistentContainer.viewContext
        
        if T.self == PlayerInfo.self {
            let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerId == %@", playerId)
            if let result = try? context.fetch(request).first {
                return PlayerInfo(
                    playerId: result.playerId,
                    name: result.name,
                    nationality: result.nationality,
                    club: result.club
                ) as? T
            }
        } else if T.self == LastSearchedPlayerInfo.self {
            let request: NSFetchRequest<LastSearchedEntity> = LastSearchedEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerId == %@", playerId)
            if let result = try? context.fetch(request).first {
                return LastSearchedPlayerInfo(
                    playerId: result.playerId,
                    name: result.name,
                    nationality: result.nationality,
                    club: result.club,
                    lastSearched: result.lastSearched
                ) as? T
            }
        }
        
        return nil
    }
    
    func isPlayerFavorited(playerId: String) -> Bool {
        let playerInfo: PlayerInfo? = loadPlayerInfo(playerId: playerId)
        return playerInfo != nil
    }
    
    // Generic function to fetch all entities of a given type
    func fetchAll<T: Codable>() -> [T] {
        let context = persistentContainer.viewContext

        if T.self == PlayerInfo.self {
            let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
            do {
                let playerEntities = try context.fetch(fetchRequest)
                return playerEntities.compactMap {
                    PlayerInfo(
                        playerId: $0.playerId,
                        name: $0.name,
                        nationality: $0.nationality,
                        club: $0.club
                    ) as? T
                }
            } catch {
                print("Failed to fetch players: \(error)")
            }
        } else if T.self == LastSearchedPlayerInfo.self {
            let fetchRequest: NSFetchRequest<LastSearchedEntity> = LastSearchedEntity.fetchRequest()

            // Adding sort descriptor for descending order based on `lastSearched`
            let sortDescriptor = NSSortDescriptor(key: #keyPath(LastSearchedEntity.lastSearched), ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]

            do {
                let lastSearchedEntities = try context.fetch(fetchRequest)
                return lastSearchedEntities.compactMap {
                    LastSearchedPlayerInfo(
                        playerId: $0.playerId,
                        name: $0.name,
                        nationality: $0.nationality,
                        club: $0.club,
                        lastSearched: $0.lastSearched
                    ) as? T
                }
            } catch {
                print("Failed to fetch last searched players: \(error)")
            }
        }
        return []
    }

    // Updated deleteAll method accepting EntityType
    func deleteAll(entityType: EntityType) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        switch entityType {
        case .player:
            fetchRequest = PlayerEntity.fetchRequest()
        case .lastSearched:
            fetchRequest = LastSearchedEntity.fetchRequest()
        }
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error deleting all entities of type \(entityType):", error)
        }
    }

    // Updated delete function accepting EntityType
    func delete(entityType: EntityType, playerId: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        switch entityType {
        case .player:
            fetchRequest = PlayerEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "playerId == %@", playerId)

        case .lastSearched:
            fetchRequest = LastSearchedEntity.fetchRequest()
        }
                
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
            }
            try context.save()
        } catch {
            print("Error deleting entity with ID \(playerId):", error)
        }
    }
    
    func exceededMaximumNumberOfEntries(isPro: Bool) -> Bool {
        let data: [LastSearchedPlayerInfo] = fetchAll()
        return data.count >= (isPro ? 12 : 10)
    }
    
    // Updated delete function accepting deletion by oldest lastSearched
    func deleteOldestLastSearched() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LastSearchedEntity> = LastSearchedEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(LastSearchedEntity.lastSearched), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            if let oldest = results.first {
                context.delete(oldest)
                try context.save()
            }
        } catch {
            debugPrint("Error deleting oldest last searched entry:", error)
        }
    }
}
