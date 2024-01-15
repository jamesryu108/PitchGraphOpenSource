//
//  WhatsNewData.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public struct WhatsNewData {
    public let versionNumber: Double
    public let whatsNewDetails: [String]
    
    public init(
        versionNumber: Double,
        whatsNewDetails: [String]
    ) {
        self.versionNumber = versionNumber
        self.whatsNewDetails = whatsNewDetails
    }
}
