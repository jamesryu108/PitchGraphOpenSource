//
//  Coordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-13.
//

import UIKit

/// A collection of property and functions that are components of Coordinator class.
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func popViewController()
    func presentModal(_ viewController: UIViewController, animated: Bool)
    /// Dismisses the currently presented modal view controller.
    /// - Parameter animated: Specifies if the dismissal should be animated.
    func dismissModal(animated: Bool)
    /// Resets the navigation flow to the root view controller. Will start implementing this once there are multiple vcs pushed onto the root view controller.
    /// - Returns: Self, for method chaining.
}

extension Coordinator {
    /// Pops the top-most vc from the navigationController. `popViewController()` can be extended as extension function of `Coordinator` protocol because the behavior of it can be generalized across all coordinators.
    func popViewController() {
        navigationController.popViewController(animated: false)
    }
}
