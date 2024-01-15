//
//  OctagonData.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

public struct OctagonData {
    public var category: String
    public var rating: Double
    public var color: UIColor
    public init(
        category: String,
        rating: Double,
        color: UIColor
    ) {
        self.category = category
        self.rating = rating
        self.color = color
    }
}
