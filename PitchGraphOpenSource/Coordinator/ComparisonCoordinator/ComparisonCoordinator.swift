//
//  ComparisonCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class ComparisonCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
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
