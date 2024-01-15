//
//  CloudStatusHeaderView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

// MARK: - Custom UICollectionReusableView for Header
/// `CloudStatusHeaderView` is a subclass of `UICollectionReusableView` used for displaying header views in collection views.
/// It primarily consists of a title label for section headers.
final class CloudStatusHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    
    enum Constants {
        static let labelHorizontalPadding: CGFloat = 8
    }
    
    // MARK: - Properties
    /// Static property to provide a reusable identifier for the header view.
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - UI objects
    /// Title label used to display the section header's title.
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.isAccessibilityElement = true
        title.accessibilityHint = "Displays the title of the cloud status section".localized
        return title
    }()
    
    // MARK: - Initializers
    /// Initializes the header view with a specified frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // Sets up the user interface components
        adjustFontsSize() // Adjusts font size initially
        setupFontSizeAdjustmentObserver() // Observes changes in font size
    }
    
    /// Required initializer for decoding from a nib or storyboard (not implemented in this case).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    /// Sets up the user interface components of the header view.
    private func setupUI() {
        addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.anchor(
            left: self.leftAnchor,
            horizontalLeftSpace: Constants.labelHorizontalPadding,
            right: self.rightAnchor,
            horizontalRightSpace: Constants.labelHorizontalPadding,
            centerY: self.centerYAnchor
        )
    }
}

// MARK: - FontAdjustable delegate functions
extension CloudStatusHeaderView: FontAdjustable {
    
    /// Adjusts the font size of the title label based on the user's preferred content size.
    /// This method is called to dynamically adjust the font size, particularly useful for supporting Dynamic Type.
    @objc func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: 18, // Minimum font size
            maxFontSize: 24, // Maximum font size
            forTextStyle: .body, // Text style to be applied
            isBlackWeight: true // Whether to use a bold font weight
        )
    }
    
    /// Sets up an observer for font size adjustment notifications to dynamically adjust the font size.
    /// This ensures the header view responds to changes in the user's preferred text size.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustFontsSize),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
}

