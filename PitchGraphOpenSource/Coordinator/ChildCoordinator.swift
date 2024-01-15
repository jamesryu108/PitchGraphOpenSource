//
//  ChildCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// All Child coordinators should conform to this protocol
protocol ChildCoordinator: Coordinator {
    /**
     The body of this function should call `childDidFinish(_ child:)` on the parent coordinator to remove the child from parent's `childCoordinators`.
     */
    func coordinatorDidFinish()
    /// A reference to the view controller used in the coordinator.
    var viewControllerRef: UIViewController? { get set }
}
