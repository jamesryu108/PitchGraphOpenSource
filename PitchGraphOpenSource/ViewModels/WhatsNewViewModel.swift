//
//  WhatsNewViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `WhatsNewViewModel` is responsible for managing the data presented in the `WhatsNewViewController`.
/// It fetches and stores information about the new features or updates introduced in different app versions.
public final class WhatsNewViewModel {
    
    // MARK: - Data

    /// The current version number of the app.
    /// This property retrieves the app's version number from the Info.plist file.
    /// The version number is used to display relevant updates to the user.
    /// If the version number is not found, it defaults to an empty string.
    public let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    /// An array of `WhatsNewData` objects, each representing updates for a specific version of the app.
    /// This array is used to populate the sections in the collection view of the `WhatsNewViewController`.
    /// Each `WhatsNewData` object contains a version number and a list of update details for that version.
    /// Example: `WhatsNewData(versionNumber: 1.0, whatsNewDetails: ["Feature 1", "Improvement 2"])`
    public let whatsNewData: [WhatsNewData] = [
        // Example data for version 1.0
        WhatsNewData(versionNumber: 1.0, whatsNewDetails: [
            "Well, it's v1.0, so everything is brand new".localized
        ])
    ]
    
    public init() {
    }
}
