//
//  CloudStatusViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import CloudKit
import Foundation

/// ViewModel for managing and updating the status of cloud services and network connectivity.
public final class CloudStatusViewModel {
    
    // Constants defining indices for cloud data.
    public enum Indexes {
        public static let network = 0
        public static let iCloudAccount = 1
    }
    
    // Observable properties that trigger UI updates on change.
    @Published public var cloudData: [CloudStatus] = [
        CloudStatus(name: "Availability".localized, cloudStatus: [
            CloudStatusDetails(
                imageName: "network",
                name: "Network".localized,
                status: "Checking...".localized,
                cloudStatus: nil
            ),
            CloudStatusDetails(
                imageName: "icloud.fill",
                name: "iCloud Account".localized,
                status: "Checking...".localized,
                cloudStatus: nil
            )
        ])
    ]
    
    @Published public private(set) var cloudError: CloudStatusError?
    @Published public private(set) var isNetworkCheckInProgress: Bool = false
    
    // Service responsible for performing network checks, injected via dependency injection.
    private let networkService: NetworkServiceProtocol
    
    /// Initializer with dependency injection of network service.
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        // Asynchronously checking the network status at initialization.
        makeNetworkCalls()
    }
    
    public func makeNetworkCalls() {
        Task.init {
            await checkNetworkStatus()
            await checkICloudAccountStatus()
        }
    }
    
    /// Asynchronously checks the network status and updates the ViewModel accordingly.
    @MainActor
    public func checkNetworkStatus() async {
        
        // Ensure the network check URL is valid.
        guard let url = URL(string: NetworkConstants.networkCheckURL) else {
                updateInitialNetworkStatus(with: "Invalid URL for network check".localized)
            return
        }
        
        // Indicate network check is in progress.
        isNetworkCheckInProgress = true
        
        do {
            // Perform network check and handle response.
            let statusCode = try await networkService.performNetworkCheck(url: url)
            handleNetworkResponse(statusCode: statusCode)
        } catch {
            // Handle network check error.
            handleNetworkError(error: error)
        }
        
        // Indicate network check completion.
        self.isNetworkCheckInProgress = false
    }
    
    /// Handles the network response.
    private func handleNetworkResponse(statusCode: Int) {
        // Update cloud status based on network response.
        if statusCode == NetworkConstants.emptyResponseStatusCode {
            updateCloudStatus(
                for: Indexes.network,
                with: "Connected to the internet".localized,
                cloudStatus: .available
            )
        } else {
            updateCloudStatus(
                for: Indexes.network,
                with: "Internet connection might be limited".localized,
                cloudStatus: .restricted
            )
        }
    }
    
    /// Handles network errors.
    private func handleNetworkError(error: Error) {
        // Differentiate URLError cases and update cloud status.
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                updateCloudStatus(
                    for: Indexes.network,
                    with: "Not connected to the internet".localized,
                    cloudStatus: .restricted
                )
            case .timedOut:
                updateCloudStatus(
                    for: Indexes.network,
                    with: "Network request timed out".localized,
                    cloudStatus: .restricted
                )
            case .cannotFindHost, .cannotConnectToHost:
                updateCloudStatus(
                    for: Indexes.network,
                    with: "Cannot connect to server".localized,
                    cloudStatus: .restricted
                )
            default:
                updateCloudStatus(
                    for: Indexes.network,
                    with: "\("Network error:".localized) \(urlError.localizedDescription)",
                    cloudStatus: .restricted
                )
            }
        } else {
            // Handle non-URLError network issues.
            updateCloudStatus(
                for: Indexes.network,
                with: "\("Unknown network error:".localized) \(error.localizedDescription)",
                cloudStatus: .restricted
            )
        }
        // Update cloud error status.
        cloudError = .networkUnavailable
    }
    
    /// Asynchronously checks the iCloud account status.
    private func checkICloudAccountStatus() async {
        Task { [weak self] in
            
            guard let self else {
                return
            }
            
            struct StatusResult {
                var text: String
                var cloudStatus: CKAccountStatus?
            }

            var result: StatusResult?

            // Attempt to get iCloud account status.
            do {
                let accountStatus = try await CKContainer.default().accountStatus()
                
                // Update result based on account status.
                switch accountStatus {
                case .available:
                    result = StatusResult(text: "Signed into an iCloud account".localized, cloudStatus: .available)
                case .noAccount:
                    result = StatusResult(text: "Not signed into an iCloud account".localized, cloudStatus: .noAccount)
                case .restricted:
                    result = StatusResult(text: "Your iCloud account is restricted".localized, cloudStatus: .restricted)
                case .couldNotDetermine:
                    result = StatusResult(text: "Your iCloud account status could not be determined".localized, cloudStatus: .couldNotDetermine)
                case .temporarilyUnavailable:
                    result = StatusResult(text: "Your iCloud account is temporarily unavailable.".localized, cloudStatus: .temporarilyUnavailable)
                @unknown default:
                    result = StatusResult(text: "Unknown iCloud account status.".localized, cloudStatus: nil)
                }
            } catch {
                // Handle iCloud status check errors.
                result = StatusResult(text: "\("Error checking iCloud account:.localized") \(error.localizedDescription)", cloudStatus: nil)
            }

            // Update cloud status based on iCloud account status.
            if let result {
                await updateCloudStatusOnMainThread(
                    index: Indexes.iCloudAccount,
                    status: result.text,
                    cloudStatus: result.cloudStatus
                )
            }
        }
    }
    
    /// Updates cloud status for a specific index.
    private func updateCloudStatus(
        for index: Int,
        with status: String,
        cloudStatus: CKAccountStatus?
    ) {
        // Ensure valid index before updating.
        guard cloudData.indices.contains(0), cloudData[0].cloudStatus.indices.contains(index) else {
            return
        }
        
        // Update the specified cloud status.
        cloudData[0].cloudStatus[index].status = status
        cloudData[0].cloudStatus[index].cloudStatus = cloudStatus
    }
    
    /// New function marked with @MainActor to ensure it runs on the main thread.
    @MainActor
    private func updateCloudStatusOnMainThread(
        index: Int,
        status: String,
        cloudStatus: CKAccountStatus?
    ) {
        updateCloudStatus(for: index, with: status, cloudStatus: cloudStatus)
    }
    
    /// Updates the initial network status in case of an invalid URL.
    private func updateInitialNetworkStatus(with message: String) {
        // Set the network status to temporarily unavailable with a specific message.
        self.updateCloudStatus(for: Indexes.network, with: message, cloudStatus: .temporarilyUnavailable)
    }
}
