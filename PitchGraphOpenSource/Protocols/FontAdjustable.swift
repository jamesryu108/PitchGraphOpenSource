//
//  FontAdjustable.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `FontAdjustable` is a protocol that provides a mechanism for adjusting font sizes and setting up font size adjustment observers.
/// It's designed to ensure that UI elements such as UILabels and UIButtons dynamically adjust their font sizes based on the user's preferred content size.
@objc public protocol FontAdjustable {
    
    /// Adjusts the font size of a UILabel.
    /// This method allows dynamic font size adjustments for labels based on minimum and maximum font size parameters.
    /// - Parameters:
    ///   - label: The UILabel whose font size is to be adjusted.
    ///   - minFontSize: The minimum font size to be applied.
    ///   - maxFontSize: The maximum font size to be applied.
    ///   - forTextStyle: The UIFont.TextStyle to be applied. This could be body, headline, etc.
    ///   - isBlackWeight: A Boolean value indicating if the font weight should be 'black' (heaviest).
    @objc optional func adjustFontSize(for label: UILabel, minFontSize: CGFloat, maxFontSize: CGFloat, forTextStyle: UIFont.TextStyle, isBlackWeight: Bool)
    
    /// Adjusts the font size of a UIButton's title.
    /// Similar to adjustFontSize(for label:), but specifically tailored for UIButton's title text.
    /// - Parameters:
    ///   - button: The UIButton whose title font size is to be adjusted.
    ///   - minFontSize: The minimum font size to be applied.
    ///   - maxFontSize: The maximum font size to be applied.
    ///   - forTextStyle: The UIFont.TextStyle to be applied.
    ///   - isBlackWeight: A Boolean value indicating if the font weight should be 'black'.
    @objc optional func adjustFontSizeButtonText(for button: UIButton, minFontSize: CGFloat, maxFontSize: CGFloat, forTextStyle: UIFont.TextStyle, isBlackWeight: Bool)
    
    /// A method to be called when the font size needs to be adjusted.
    /// Typically used in response to a notification like UIContentSizeCategory.didChangeNotification.
    @objc func adjustFontsSize()
    
    /// Sets up an observer for font size adjustment notifications.
    /// It listens for changes in the user's preferred content size category and calls adjustFontsSize() in response.
    func setupFontSizeAdjustmentObserver()
    
    /// Sets up an observer for image size adjustment notifications, if necessary.
    /// This is optional and can be used for adjusting image sizes dynamically along with fonts.
    @objc optional func setupImageSizeAdjustmentObserver()
}
