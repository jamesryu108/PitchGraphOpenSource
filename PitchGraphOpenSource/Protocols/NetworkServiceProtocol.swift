//
//  NetworkServiceProtocol.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// Protocol defining the capabilities of a network service.
///
/// This protocol abstracts the functionality for performing network checks,
/// allowing for different implementations that can be injected into consumers such as ViewModels.
public protocol NetworkServiceProtocol {

    /// Performs a network check at the given URL.
    ///
    /// This function is asynchronous, meaning it can be used with `await` to perform network requests
    /// without blocking the calling thread. It's designed to be used in an async context.
    ///
    /// - Parameter url: The URL where the network check will be performed.
    /// - Returns: An integer representing the HTTP status code received from the network request.
    /// - Throws: An error if the network request fails. This allows the caller to handle different
    ///           types of network errors appropriately.
    ///
    /// Usage example:
    /// ```
    /// let status = try await networkService.performNetworkCheck(url: someURL)
    /// ```
    func performNetworkCheck(url: URL) async throws -> Int
}
