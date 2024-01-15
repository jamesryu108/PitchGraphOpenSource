//
//  PlayerCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class PlayerCoordinator: ChildCoordinator {

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

extension PlayerCoordinator {
    func navigateToPlayerVC() {
        parent?.playerScreen(navigationController: navigationController)
    }
}
