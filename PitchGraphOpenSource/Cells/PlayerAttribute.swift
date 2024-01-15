//
//  PlayerAttribute.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

struct PlayerAttribute: Hashable {
    var title: String
    var value: String
    var unit: String?
    
    init(title: String, value: String, unit: String? = nil) {
        self.title = title
        self.value = value
        self.unit = unit
    }
}
