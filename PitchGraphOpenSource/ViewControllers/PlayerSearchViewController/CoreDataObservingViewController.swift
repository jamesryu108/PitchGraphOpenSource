//
//  CoreDataObservingViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

// This class is designed as a base view controller for observing updates in Core Data.
class CoreDataObservingViewController: UIViewController {
    
    // MARK: - Lifecycle methods
    // viewDidLoad() is called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Calls a method to add this view controller as an observer for Core Data updates.
        addCoreDataUpdateObserver()
    }
    
    // MARK: - Observer stuff
    // This function adds the view controller as an observer for Core Data updates.
    func addCoreDataUpdateObserver() {
        // The NotificationCenter is used to add an observer that listens for a specific notification.
        // Here, the observer is set to listen for notifications indicating that Core Data has been updated.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCoreDataUpdate),
            name: .coreDataDidUpdate,
            object: nil
        )
    }
    
    // This function is the handler called when the Core Data update notification is received.
    // It is annotated with @objc to allow it to be used as a selector for NotificationCenter.
    @objc func handleCoreDataUpdate(notification: Notification.Name) {
        // This method is meant to be overridden in subclasses to provide specific functionality
        // when a Core Data update occurs. It's empty in this base class.
    }
    
    // deinit is called just before the object is deallocated.
    deinit {
        // Removes this object as an observer for Core Data updates to avoid memory leaks or crashes.
        NotificationCenter.default.removeObserver(
            self,
            name: .coreDataDidUpdate,
            object: nil
        )
    }
}
