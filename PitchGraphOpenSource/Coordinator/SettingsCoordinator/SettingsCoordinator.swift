//
//  SettingsCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class SettingsCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsViewModel = SettingsViewModel()
        let settingsVC = SettingsViewController(
            coordinator: self,
            viewModel: settingsViewModel
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

extension SettingsCoordinator {
    func settingsStatsScreen(navigationController: UINavigationController) {
        parent?.statsScreen(navigationController: navigationController)
    }
    func cloudScreen(navigationController: UINavigationController) {
        parent?.iCloudScreen(navigationController: navigationController)
    }
    func whatsNewScreen(navigationController: UINavigationController) {
        parent?.whatsNewScreen(navigationController: navigationController)
    }
}
