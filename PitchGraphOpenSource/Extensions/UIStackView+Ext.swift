//
//  UIStackView+Ext.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

extension UIStackView {
    /// Adds multiple subviews to the view.
    /// - Parameter views: A variadic list of UIViews to be added.
    public func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}
