//
//  StatsSettingsCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class StatsSettingsCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userDefaultsManager = UserDefaultsManager.shared
        let settingsViewModel = StatsSettingsViewModel(userDefaults: userDefaultsManager, player1: PlayerData.messiPlayerData)
        let settingsVC = StatsSettingsViewController(
            coordinator: self,
            viewModel: settingsViewModel,
            userDefaults: userDefaultsManager
        )
        
        presentModal(UINavigationController(rootViewController: settingsVC), animated: true)
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool) {
        navigationController.topViewController?.present(viewController, animated: animated)
    }
    
    func dismissModal(animated: Bool) {
        self.navigationController.topViewController?.dismiss(animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}

extension StatsSettingsCoordinator {
    func settingsStatsScreen() {
        parent?.statsScreen(navigationController: navigationController)
    }
    func cloudScreen() {
        parent?.iCloudScreen(navigationController: navigationController)
    }
}
