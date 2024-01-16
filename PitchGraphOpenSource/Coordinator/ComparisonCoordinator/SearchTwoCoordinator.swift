//
//  SearchTwoCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class SearchTwoCoordinator: ChildCoordinator {
    
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
        let viewModel = ComparisonViewModel()
        let searchTwoViewController = SearchTwoPlayersViewController(
            coordinator: self,
            userDefaultsManager: userDefaultsManager,
            viewModel: viewModel
        )
        
        searchTwoViewController.tabBarItem = UITabBarItem(
            title: "Compare",
            image: UIImage(systemName: "person.fill"),
            tag: 1
        )
        
        navigationController.pushViewController(
            searchTwoViewController,
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
