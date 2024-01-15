//
//  NetworkCaller.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public protocol NetworkCalling {
    func fetchData<T: Decodable>(from url: String) async throws -> T
}

public final class NetworkCaller: NetworkCalling {
    
    public let headers = [
        "X-RapidAPI-Key": "f426ce4254msh8775cb631eae03ap1ecc18jsn651fffabe3be",
        "X-RapidAPI-Host": "football-manager-api.p.rapidapi.com"
    ]
    
    public enum NetworkError: String, Error {
        case invalidInputs = "The inputs created an invalid request. Please retry."
        case unableToComplete = "Unable to complete your request. Please check your internet connection."
        case invalidResponse = "Invalid response from server. Please retry."
        case invalidData = "Invalid data received from server. Please retry."
    }
    
    public static let baseURLPlayerSearch: String = "https://football-manager-api.p.rapidapi.com/players"
    public static let shared = NetworkCaller()
    private init() {}
    // MARK: - CodeAI Output
    public func fetchData<T: Decodable>(from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            
            throw NetworkError.invalidInputs
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.invalidData
        }
    }
}

extension NetworkCaller {
    func makeURL(forPath path: String, withQueryItems queryItems: [URLQueryItem]) throws -> String {
        var components = URLComponents(string: path)
        components?.queryItems = queryItems
        
        guard let url = components?.url?.absoluteString else {
            throw NetworkError.invalidInputs
        }
        
        return url
    }
    
    // MARK: - Utility Methods
    /// Converts search parameters to URL query items for network requests.
    /// - Parameter searchParameters: The search parameters to convert.
    /// - Returns: An array of URLQueryItem representing the search parameters.
    func searchParametersToQueryItems(_ searchParameters: SearchParameter) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "minAge", value: String(searchParameters.ageRange.lowerBound)))
        queryItems.append(URLQueryItem(name: "maxAge", value: String(searchParameters.ageRange.upperBound)))
        queryItems.append(URLQueryItem(name: "minCa", value: String(searchParameters.abilityRange.lowerBound)))
        queryItems.append(URLQueryItem(name: "maxCa", value: String(searchParameters.abilityRange.upperBound)))
        queryItems.append(URLQueryItem(name: "minPa", value: String(searchParameters.potentialRange.lowerBound)))
        queryItems.append(URLQueryItem(name: "maxPa", value: String(searchParameters.potentialRange.upperBound)))
        
        if searchParameters.sortOption != .nothing {
            queryItems.append(URLQueryItem(name: "orderBy", value: sortOptionToString(searchParameters.sortOption)))
        }
        
        return queryItems
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
