//
//  GoalKeeperAttribute.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct GoalKeeperAttribute {
    public var name: String
    public var score: Int
    public init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}
