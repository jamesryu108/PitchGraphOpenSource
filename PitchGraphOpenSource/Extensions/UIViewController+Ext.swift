//
//  UIViewController+Ext.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

extension UIViewController {
    public var topmostPresentedViewController: UIViewController {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    public func presentPGAlertOnMainThread(vc: UIViewController) {
        DispatchQueue.main.async {
            vc.modalPresentationStyle  = .overFullScreen
            vc.modalTransitionStyle    = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    public func showAlert(
        title: String,
        message: String,
        preferredStyle: UIAlertController.Style
    ) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        let okAction = UIAlertAction(
            title: "Okay".localized,
            style: .default
        ) { (action) in }
        
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
}

extension UIViewController {
    /// Adds a child view controller to the specified container view.
    public func addChildViewController(_ childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Or set up constraints here
        childVC.didMove(toParent: self)
    }

    /// Removes a child view controller from its parent.
    public func removeChildViewController(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
    public func removeChildViewControllers(_ childVCs: [UIViewController]) {
        childVCs.forEach { vc in
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
}
