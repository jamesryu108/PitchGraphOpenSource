//
//  VersionProvider.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

// MARK: - VersionProviding Protocol
public protocol VersionProviding {
    var versionNumber: String { get }
}

// MARK: - Default Implementation
public struct VersionProvider: VersionProviding {
    public var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public init() {
        
    }
}
