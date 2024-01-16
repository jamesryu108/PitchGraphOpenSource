//
//  PlayerSearchCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class PlayerSearchCoordinator: ChildCoordinator {

    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func start() {
        let userDefaultsManager = UserDefaultsManager.shared
        let playerSearchViewModel = PlayerSearchViewModel()
        let playerSearchViewController = PlayerSearchViewController(
            coordinator: self,
            viewModel: playerSearchViewModel,
            userDefaultsManager: userDefaultsManager
        )
        viewControllerRef = playerSearchViewController
        
        playerSearchViewController.coordinator = self
        playerSearchViewController.tabBarItem = UITabBarItem(
            title: "Player",
            image: UIImage(systemName: "person.fill"),
            tag: 0
        )
        
        navigationController.pushViewController(
            playerSearchViewController,
            animated: false
        )
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool) {
        navigationController.topViewController?.present(
            viewController,
            animated: animated
        )
    }
    
    func dismissModal(animated: Bool) {
        navigationController.topViewController?.dismiss(animated: animated)
    }
}

extension PlayerSearchCoordinator {
    func navigateToSettings() {
        parent?.settingsScreen(navigationController: navigationController)
    }
    
    func navigateToPlayerVC() {
        parent?.playerScreen(navigationController: navigationController)
    }
}
