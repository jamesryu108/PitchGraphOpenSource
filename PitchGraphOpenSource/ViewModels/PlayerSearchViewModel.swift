//
//  PlayerSearchViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `PlayerSearchViewModel` is responsible for the business logic associated with player search in the PitchGraph app. It handles fetching player data based on search criteria and maintaining the state of the search.
public final class PlayerSearchViewModel {
    
    /// Represents various states of the view model during the search process.
    public enum ViewModelState {
        case idle            // No current search operation
        case loading         // Search operation in progress
        case failed(Error)   // Search operation failed with an error
        case success([PlayerData]) // Search operation successful with results
    }
    
    /// Published property for the current state of the view model.
    @Published public var state: ViewModelState = .idle
    
    /// Published property for the list of fetched players.
    public var playerData: [PlayerData] = []

    /// Current search text.
    public var name: String?
    
    // MARK: - Network caller
    
    let networkCaller: NetworkCalling

    // MARK: - Initializers
    
    public init(networkCaller: NetworkCalling = NetworkCaller.shared) {
        state = .idle
        self.networkCaller = networkCaller
    }
    
    /// Fetches players based on the search name and parameters asynchronously.
    /// - Parameters:
    ///   - name: The name to search for.
    ///   - searchParameters: Optional parameters to refine the search.
    public func getPlayers(
        name: String,
        searchParameters: SearchParameter? = nil,
        isDebug: Bool
    ) async throws {
        
        state = .loading

        if isDebug {
            await fetchMockData()
        } else {
            // Real API call for production
            await fetchPlayerData(name: name, searchParameters: searchParameters)
        }
    }
    /// Fetches mock data for testing purposes.
    public func fetchMockData() async {
        let mockPlayers: [PlayerData] = [
            PlayerData.messiPlayerData,
            PlayerData.onanaPlayerData,
            PlayerData.sonPlayerData,
            PlayerData.donnaRummaPlayerData,
            PlayerData.kimPlayerData
        ]
        // Simulate a network delay if needed
        state = .success(mockPlayers)
    }
    
    /// Fetches player data from the network based on the given search parameters.
    /// - Parameters:
    ///   - name: The name of the player to be searched.
    ///   - searchParameters: Optional search parameters to refine the player search.
    public func fetchPlayerData(name: String, searchParameters: SearchParameter? = nil) async {
        do {
            // Constructing the URL components for the network request
            var components = URLComponents(string: NetworkCaller.baseURLPlayerSearch)

            components?.queryItems = makeQueryItem(name: name, searchParameters: searchParameters)

            // Finalizing the URL and making the network call
            guard let finalURL = components?.url else {
                throw NetworkCaller.NetworkError.invalidInputs
            }

            // Fetching player data from the network
            let players: [PlayerData] = try await networkCaller.fetchData(from: finalURL.absoluteString)
            
            state = .success(players)
            
        } catch {
            state = .failed(error)
        }
        state = .idle
    }
    
    /// Constructs query items for the network request based on search criteria.
    /// - Parameters:
    ///   - name: The name of the player for the search.
    ///   - searchParameters: Optional parameters to refine the search.
    /// - Returns: An array of URLQueryItem representing the search criteria.
    public func makeQueryItem(name: String, searchParameters: SearchParameter?) -> [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "name", value: name))

        // Adding search parameters to the query if they exist
        if let searchParameters {
            queryItems.append(URLQueryItem(name: "minAge", value: String(searchParameters.ageRange.lowerBound)))
            queryItems.append(URLQueryItem(name: "maxAge", value: String(searchParameters.ageRange.upperBound)))
            queryItems.append(URLQueryItem(name: "minCa", value: String(searchParameters.abilityRange.lowerBound)))
            queryItems.append(URLQueryItem(name: "maxCa", value: String(searchParameters.abilityRange.upperBound)))
            queryItems.append(URLQueryItem(name: "minPa", value: String(searchParameters.potentialRange.lowerBound)))
            queryItems.append(URLQueryItem(name: "maxPa", value: String(searchParameters.potentialRange.upperBound)))

            if searchParameters.sortOption != .nothing {
                queryItems.append(URLQueryItem(name: "orderBy", value: sortOptionToString(searchParameters.sortOption)))
            }
        }
        
        return queryItems
    }

    /// Clears the current list of players.
    /// This function is used to reset the player data to an empty state.
    public func clearPlayers() {
        playerData.removeAll()
        state = .idle
    }
    
    /// Converts a `SortOption` enum value to a corresponding string value for URL query.
    /// - Parameter sortOption: The `SortOption` enum value to convert.
    /// - Returns: A string representation of the sort option.
    private func sortOptionToString(_ sortOption: SortOption) -> String {
        // Convert SortOptions enum to a string for the URL query
        switch sortOption {
        case .ageAscending:
            return "age-asc"
        case .ageDescending:
            return "age-desc"
        case .currentAbilityAscending:
            return "currentAbility-asc"
        case .currentAbilityDescending:
            return "currentAbility-desc"
        case .potentialAbilityAscending:
            return "potentialAbility-asc"
        case .potentialAbilityDescending:
            return "potentialAbility-desc"
        default:
            return "" // Default case
        }
    }
}
