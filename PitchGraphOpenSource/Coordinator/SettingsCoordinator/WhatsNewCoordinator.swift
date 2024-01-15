//
//  WhatsNewCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class WhatsNewCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let whatsNewViewModel = WhatsNewViewModel()
        let whatsNewVC = WhatsNewViewController(
            coordinator: self,
            viewModel: whatsNewViewModel
        )
        
        presentModal(UINavigationController(rootViewController: whatsNewVC), animated: true)
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
