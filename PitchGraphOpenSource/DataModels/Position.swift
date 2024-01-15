//
//  Position.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct Position: Identifiable {
    public var id: String
    public var name: String
    public var x: CGFloat
    public var y: CGFloat
    public var isEnabled: Bool
    public init(
        id: String,
        name: String,
        x: CGFloat,
        y: CGFloat,
        isEnabled: Bool
    ) {
        self.id = id
        self.name = name
        self.x = x
        self.y = y
        self.isEnabled = isEnabled
    }
}
