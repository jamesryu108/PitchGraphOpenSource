//
//  CloudStatusCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class CloudStatusCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let networkCaller = NetworkService()
        let cloudViewModel = CloudStatusViewModel(networkService: networkCaller)
        let cloudVC = CloudStatusViewController(
            coordinator: self,
            viewModel: cloudViewModel
        )
        
        presentModal(UINavigationController(rootViewController: cloudVC), animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool) {
        navigationController.topViewController?.present(viewController, animated: animated)
    }
    
    func dismissModal(animated: Bool) {
        self.navigationController.topViewController?.dismiss(animated: true)
    }
}
