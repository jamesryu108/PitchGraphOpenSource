//
//  NetworkService.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

// MARK: - NetworkService

/// A service for performing network operations,
final public class NetworkService: NetworkServiceProtocol {

    /// Performs a network check and returns the status code.
    /// - Parameter url: The URL to perform the network check.
    /// - Returns: The status code of the network response.
    /// - Throws: An `Error` if the network request fails.
    public func performNetworkCheck(url: URL) async throws -> Int {
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return httpResponse.statusCode
    }
    
    public init() {
        
    }
}
