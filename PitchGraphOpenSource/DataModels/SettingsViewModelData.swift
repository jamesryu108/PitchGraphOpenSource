//
//  SettingsViewModelData.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

public struct SettingsViewModelData {
    public let title: String
    public let image: String
    public let color: UIColor
    
    public init(title: String, image: String, color: UIColor) {
        self.title = title
        self.image = image
        self.color = color
    }
}
