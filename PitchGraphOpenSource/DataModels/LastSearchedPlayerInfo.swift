//
//  LastSearchedPlayerInfo.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct LastSearchedPlayerInfo: Codable, Equatable, Hashable {
    public var playerId: String?
    public var name: String?
    public var nationality: String?
    public var club: String?
    public var lastSearched: Date?
    
    public init(
        playerId: String? = nil,
        name: String? = nil,
        nationality: String? = nil,
        club: String? = nil,
        lastSearched: Date? = nil
    ) {
        self.playerId = playerId
        self.name = name
        self.nationality = nationality
        self.club = club
        self.lastSearched = lastSearched
    }
}
