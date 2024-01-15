//
//  CloudStatusError.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// Enum representing various types of errors that can occur while checking cloud status.
///
/// This enum defines a set of possible error conditions that might be encountered during
/// the process of checking the network status or iCloud account availability.
/// It conforms to the `Error` protocol, allowing it to be used in error handling.
public enum CloudStatusError: Error {

    /// Indicates that the network is unavailable.
    /// This error is used when the device is not connected to the internet.
    case networkUnavailable

    /// Indicates that the iCloud account is unavailable.
    /// This error might occur if the user is not signed into an iCloud account or the account is inaccessible.
    case iCloudAccountUnavailable

    /// Indicates that the network is restricted.
    /// This error can occur in situations where network access is limited, such as a restricted corporate or public network.
    case restrictedNetwork

    /// Represents an unknown or unspecified error.
    /// This case is used as a fallback for errors that don't fit into the other specified categories.
    case unknownError
}
