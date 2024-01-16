//
//  BaseTabBarController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    
    weak var coordinator: MainCoordinator?
    
    private let playerCoordinator = PlayerSearchCoordinator(navigationController: UINavigationController())
    private let searchTwoCoordinator = SearchTwoCoordinator(navigationController: UINavigationController())
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPlayerCoordinator()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    private func setupPlayerCoordinator() {
        playerCoordinator.parent = coordinator
        searchTwoCoordinator.parent = coordinator
        
        for item in [playerCoordinator] as [Any] {
            coordinator?.addChild(item as? Coordinator)
        }
        
        playerCoordinator.start()
        searchTwoCoordinator.start()
        viewControllers = [playerCoordinator.navigationController, searchTwoCoordinator.navigationController]
    }
}
