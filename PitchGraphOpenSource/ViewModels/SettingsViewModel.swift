//
//  SettingsViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

final class SettingsViewModel {

    // MARK: - Constants
    private struct Constants {
        static let themeSection = "Theme".localized
        static let iCloudSection = "iCloud Stuff".localized
        static let helpSection = "Help me".localized
        static let aboutSection = "About".localized
        static let statsTitle = "Stats".localized
        static let iCloudStatusTitle = "iCloud Status".localized
        static let leaveReviewTitle = "Leave a Review".localized
        static let termsOfServiceTitle = "Terms of Service".localized
        static let privacyPolicyTitle = "Privacy Policy".localized
        static let whatsNewTitle = "What's new in".localized
        // Add other constants here
    }

    // MARK: - Data
    public let versionNumber: String
    public lazy var settingsData: [SettingsData] = createSettingsData()

    // MARK: - Initializers
    public init(versionProvider: VersionProviding = VersionProvider()) {
        self.versionNumber = versionProvider.versionNumber
    }

    // MARK: - Private Methods
    private func createSettingsData() -> [SettingsData] {
        [
            SettingsData(
                sectionTitle: Constants.themeSection,
                subSection: [
                    SubSectionData(
                        title: Constants.statsTitle,
                        image: "pencil",
                        color: .systemOrange
                    )
                ]
            ),
            SettingsData(
                sectionTitle: Constants.iCloudSection.localized,
                subSection: [
                    SubSectionData(
                        title: Constants.iCloudStatusTitle,
                        image: "icloud.fill",
                        color: .systemBlue
                    )
                ]
            ),
            SettingsData(
                sectionTitle: Constants.helpSection,
                subSection: [
                    SubSectionData(
                        title: Constants.leaveReviewTitle,
                        image: "heart.fill",
                        color: .systemPink
                    )
                ]
            ),
            SettingsData(
                sectionTitle: Constants.aboutSection,
                subSection: [
                    SubSectionData(
                        title: Constants.termsOfServiceTitle,
                        image: "doc.text.fill",
                        color: .systemBlue
                    ),
                    SubSectionData(
                        title: Constants.privacyPolicyTitle,
                        image: "doc.text.fill",
                        color: .systemGray2
                    ),
                    SubSectionData(
                        title: "\(Constants.whatsNewTitle) \(versionNumber)",
                        image: "exclamationmark.circle",
                        color: .systemBrown
                    )
                ]
            )
        ]
    }
}
