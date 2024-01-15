//
//  PlayerInfo.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct PlayerInfo: Codable, Equatable, Hashable {
    public var playerId: String?
    public var name: String?
    public var nationality: String?
    public var club: String?
    
    public init(
        playerId: String? = nil,
        name: String? = nil,
        nationality: String? = nil,
        club: String? = nil
    ) {
        self.playerId = playerId
        self.name = name
        self.nationality = nationality
        self.club = club
    }
}
