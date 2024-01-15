//
//  ParentCoordinator.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import Foundation

protocol ParentCoordinator: Coordinator {
    /// Each Coordinator can have its own children coordinators
    var childCoordinators: [Coordinator] { get set }
    /// Adds the given coordinator to the list of children
    func addChild(_ child: Coordinator?)
    /// Tells the parent coordinator that given coordinator is done and should be removed from the list of children.
    func childDidFinish(_ child: Coordinator?)
}

// MARK: - ParentCoordinator Extension funcs
extension ParentCoordinator {
    func addChild(_ child: Coordinator?){
        if let child {
            childCoordinators.append(child)
        }
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
