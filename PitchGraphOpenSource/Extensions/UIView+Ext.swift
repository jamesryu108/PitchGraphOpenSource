//
//  UIView+Ext.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

extension UIView {
    /// Sets up constraints for the view based on the specified anchors and dimensions.
    ///
    /// This method provides a convenient way to define a view's layout using Auto Layout by specifying its
    /// top, bottom, left, right anchors, width, height, and center constraints if needed.
    ///
    /// - Parameters:
    ///   - top: The top anchor to constrain to.
    ///   - verticalTopSpace: The vertical spacing for the top anchor.
    ///   - bottom: The bottom anchor to constrain to.
    ///   - verticalBottomSpace: The vertical spacing for the bottom anchor.
    ///   - left: The left anchor to constrain to.
    ///   - horizontalLeftSpace: The horizontal spacing for the left anchor.
    ///   - right: The right anchor to constrain to.
    ///   - horizontalRightSpace: The horizontal spacing for the right anchor.
    ///   - width: The width of the view.
    ///   - height: The height of the view.
    ///   - centerX: The center X anchor to align to.
    ///   - centerY: The center Y anchor to align to.
    ///
    /// Usage example:
    /// ```
    /// someView.anchor(top: parentView.topAnchor, verticalTopSpace: 10,
    ///                 left: parentView.leftAnchor, horizontalLeftSpace: 20,
    ///                 right: parentView.rightAnchor, horizontalRightSpace: 20,
    ///                 height: 200)
    /// ```
    public func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        verticalTopSpace: CGFloat? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        verticalBottomSpace: CGFloat? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        horizontalLeftSpace: CGFloat? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        horizontalRightSpace: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: verticalTopSpace!).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -verticalBottomSpace!).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -horizontalRightSpace!).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: horizontalLeftSpace!).isActive = true
        }
        if let width = width, width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height, height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

extension UIView {
    /// Finds the UIViewController that this view resides in, if any.
    ///
    /// This method traverses the responder chain to locate the UIViewController
    /// that the current UIView is a part of.
    ///
    /// - Returns: The UIViewController if the view is part of one, otherwise nil.
    ///
    /// Usage example:
    /// ```
    /// let viewController = someView.findViewController()
    /// ```
    public func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIView {
    /// Adjusts the font size of a UILabel within specified limits and style.
    ///
    /// This method allows dynamic adjustment of a UILabel's font size based on the user's preferred text size,
    /// with constraints on minimum and maximum sizes. It can also apply a bold weight if specified.
    ///
    /// - Parameters:
    ///   - label: The UILabel to adjust the font size for.
    ///   - minFontSize: The minimum font size.
    ///   - maxFontSize: The maximum font size.
    ///   - forTextStyle: The UIFont.TextStyle to apply.
    ///   - isBlackWeight: A Boolean value indicating whether to apply black weight to the font.
    @objc public func adjustFontSize(for label: UILabel, minFontSize: CGFloat, maxFontSize: CGFloat, forTextStyle: UIFont.TextStyle, isBlackWeight: Bool) {
        let preferredFont = UIFont.preferredFont(forTextStyle: forTextStyle)
        let clampedFontSize = min(max(preferredFont.pointSize, minFontSize), maxFontSize)

        if isBlackWeight {
            // Create a font descriptor with a black weight
            let fontDescriptor = preferredFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.black]])
            label.font = UIFont(descriptor: fontDescriptor, size: clampedFontSize)
        } else {
            // Use the regular font style
            label.font = preferredFont.withSize(clampedFontSize)
        }
    }
    
    /// Adjusts the font size of a UIButton's title within specified limits and style.
    ///
    /// Similar to adjustFontSize(for:label:...), but specifically for UIButton's title label.
    /// Ensures the button adjusts its size to fit the new font size.
    ///
    /// - Parameters are similar to adjustFontSize(for:label:...)
    @objc public func adjustFontSizeButtonText(for button: UIButton, minFontSize: CGFloat, maxFontSize: CGFloat, forTextStyle: UIFont.TextStyle, isBlackWeight: Bool) {
        guard let titleLabel = button.titleLabel else { return }

        let preferredFont = UIFont.preferredFont(forTextStyle: forTextStyle)
        let clampedFontSize = min(max(preferredFont.pointSize, minFontSize), maxFontSize)

        if isBlackWeight {
            // Create a font descriptor with a black weight
            let fontDescriptor = preferredFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.black]])
            titleLabel.font = UIFont(descriptor: fontDescriptor, size: clampedFontSize)
        } else {
            // Use the regular font style
            titleLabel.font = preferredFont.withSize(clampedFontSize)
        }

        // Ensuring the button adjusts its size to fit the new font size
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = minFontSize / clampedFontSize
    }
    
    /// Adds multiple subviews to the view.
    /// - Parameter views: A variadic list of UIViews to be added.
    public func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
