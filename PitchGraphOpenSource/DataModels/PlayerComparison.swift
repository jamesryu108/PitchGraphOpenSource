//
//  PlayerComparison.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct PlayerComparison: Hashable {
    public var id = UUID()
    public var parameter: String
    public var leftValue: String
    public var rightValue: String
    
    public init(id: UUID = UUID(), parameter: String, leftValue: String, rightValue: String) {
        self.id = id
        self.parameter = parameter
        self.leftValue = leftValue
        self.rightValue = rightValue
    }
}
