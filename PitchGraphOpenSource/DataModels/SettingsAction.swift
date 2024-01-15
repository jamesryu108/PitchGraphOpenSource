//
//  SettingsAction.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// Represents the different actions that can be triggered from the settings view.
///
/// This enum encapsulates the various settings options available in the app's settings view.
/// Each case corresponds to a specific setting option, with some cases having associated values
/// to carry additional necessary information.
///
/// - Cases:
///   - leaveReview: Represents the action to leave a review for the app.
///   - stats: Represents the action to navigate to the stats section.
///   - iCloudStatus: Represents the action to check the iCloud status.
///   - whatsNew: Represents the action to view the new features or updates in the app.
///     The associated value is a `String` representing the app's version number.
///
/// The enum also provides a failable initializer to create a `SettingsAction` from a given title string
/// and version number. This initializer facilitates the conversion from UI elements (like buttons or cells)
/// that display the setting options as text, to the corresponding actions in the app.
///
/// - Parameters:
///   - title: A string representing the title of the setting option as displayed in the UI.
///   - versionNumber: A string representing the current version number of the app.
///     This is used specifically for the `whatsNew` case to display the relevant version.
///
/// - Returns: An optional `SettingsAction` corresponding to the given title and version number.
///   If no matching action is found, the initializer returns `nil`.
public enum SettingsAction {
    case leaveReview
    case stats
    case iCloudStatus
    case whatsNew(String)

    public init?(title: String, versionNumber: String) {
        switch title {
        case "Leave a Review".localized:
            self = .leaveReview
        case "Stats".localized:
            self = .stats
        case "iCloud Status".localized:
            self = .iCloudStatus
        case "\("What's new in".localized) \(versionNumber)":
            self = .whatsNew(versionNumber)
        default:
            return nil
        }
    }
}
