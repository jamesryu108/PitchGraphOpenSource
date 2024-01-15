//
//  SettingsData.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct SettingsData {
    public let sectionTitle: String
    public let subSection: [SubSectionData]
    
    public init(sectionTitle: String, subSection: [SubSectionData]) {
        self.sectionTitle = sectionTitle
        self.subSection = subSection
    }
}
