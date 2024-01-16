//
//  LastSearchedCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class LastSearchedCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
        
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coreDataManager = CoreDataManager.shared
        let viewModel = LastSearchViewModel(coreDataManager: coreDataManager)
        let lastSearchedViewController = LastSearchedViewController(coordinator: self, viewModel: viewModel)
        lastSearchedViewController.tabBarItem = UITabBarItem(
            title: "Last Searched",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        
        navigationController.pushViewController(lastSearchedViewController, animated: false)
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
