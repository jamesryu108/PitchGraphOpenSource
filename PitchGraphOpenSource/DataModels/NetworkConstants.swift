//
//  NetworkConstants.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// A struct containing constants related to network operations.
///
/// This struct defines essential constants used in network-related tasks,
/// such as checking the availability of an internet connection. It provides a centralized
/// location for managing these constants, making it easier to maintain and update them.
public struct NetworkConstants {

    /// Represents the HTTP status code for an empty response.
    ///
    /// The status code 204 is commonly returned by servers when a request is successfully processed,
    /// but there is no content to return. This constant is used to identify such scenarios, particularly
    /// in network connectivity checks.
    public static let emptyResponseStatusCode: Int = 204

    /// The URL used for performing network availability checks.
    ///
    /// This URL points to a resource that returns a 204 status code when accessed. It's typically used to
    /// quickly and efficiently check for internet connectivity by making a lightweight network request.
    public static let networkCheckURL: String = "https://www.google.com/generate_204"
    
    /// Initializes a new instance of `NetworkConstants`.
    ///
    /// This initializer is public to allow the creation of `NetworkConstants` instances if needed,
    /// although the struct is primarily intended to be used for its static properties.
    public init() {
        
    }
}
