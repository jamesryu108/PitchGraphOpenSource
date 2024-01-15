//
//  CloudStatus.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import CloudKit
import Foundation

/// Represents the overall status of a cloud service or feature.
///
/// This structure encapsulates the name of the service and a collection of detailed statuses
/// pertaining to various aspects or components of that service.
public struct CloudStatus {

    /// The name of the cloud service or feature.
    public let name: String

    /// A collection of detailed status information for different components or aspects of the cloud service.
    public var cloudStatus: [CloudStatusDetails]
    
    /// Initializes a new instance of `CloudStatus`.
    ///
    /// - Parameters:
    ///   - name: The name of the cloud service or feature. This is used to identify the service in the UI.
    ///   - cloudStatus: An array of `CloudStatusDetails` providing detailed status for different aspects of the service.
    public init(name: String, cloudStatus: [CloudStatusDetails]) {
        self.name = name
        self.cloudStatus = cloudStatus
    }
}

/// Provides detailed status information for a specific aspect or component of a cloud service.
///
/// This structure is used to describe the status of individual components, such as network connectivity or
/// account status, within a larger cloud service.
public struct CloudStatusDetails {

    /// The name of the icon image representing the status or service.
    /// This is typically used in the UI to visually represent the component being described.
    public let imageName: String

    /// The human-readable name of the component or aspect of the cloud service.
    public var name: String

    /// A string representing the current status of this component.
    /// This could be values like "Connected", "Not Connected", "Checking...", etc.
    public var status: String

    /// An optional `CKAccountStatus` indicating the status of the iCloud account, if applicable.
    /// This is nil if the status is not related to an iCloud account.
    public var cloudStatus: CKAccountStatus?
    
    /// Initializes a new instance of `CloudStatusDetails`.
    ///
    /// - Parameters:
    ///   - imageName: The name of the icon image for the status.
    ///   - name: The name of the component or aspect.
    ///   - status: The current status as a string.
    ///   - cloudStatus: An optional `CKAccountStatus` value representing the iCloud account status.
    public init(
        imageName: String,
        name: String,
        status: String,
        cloudStatus: CKAccountStatus? = nil
    ) {
        self.imageName = imageName
        self.name = name
        self.status = status
        self.cloudStatus = cloudStatus
    }
}
