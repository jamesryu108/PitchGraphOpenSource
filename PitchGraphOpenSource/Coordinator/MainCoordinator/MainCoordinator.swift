//
//  MainCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class MainCoordinator: NSObject, Coordinator, ParentCoordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var baseTabBarController: UITabBarController = UITabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        baseTabBarController = BaseTabBarController(coordinator: self) 
        return
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool) {
        
    }
    
    func dismissModal(animated: Bool) {
        
    }
}

extension MainCoordinator {
    func settingsScreen(navigationController: UINavigationController) {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.parent = self
        addChild(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    func statsScreen(navigationController: UINavigationController) {
        let statsSettingsCoordinator = StatsSettingsCoordinator(navigationController: navigationController)
        statsSettingsCoordinator.parent = self
        addChild(statsSettingsCoordinator)
        statsSettingsCoordinator.start()
    }
    
    func iCloudScreen(navigationController: UINavigationController) {
        let iCloudCoordinator = CloudStatusCoordinator(navigationController: navigationController)
        iCloudCoordinator.parent = self
        addChild(iCloudCoordinator)
        iCloudCoordinator.start()
    }
    
    func whatsNewScreen(navigationController: UINavigationController) {
        let whatsNewCoordinator = WhatsNewCoordinator(navigationController: navigationController)
        whatsNewCoordinator.parent = self
        addChild(whatsNewCoordinator)
        whatsNewCoordinator.start()
    }
    
    func playerScreen(navigationController: UINavigationController) {
        let playerCoordinator = PlayerCoordinator(navigationController: navigationController)
        playerCoordinator.parent = self
        addChild(playerCoordinator)
        playerCoordinator.start()
    }
}

