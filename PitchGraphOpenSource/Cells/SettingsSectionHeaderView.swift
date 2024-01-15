//
//  SettingsSectionHeaderView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `SettingsSectionHeaderView` is a custom `UICollectionReusableView` designed for displaying section headers in collection views.
/// It features a configurable title label to display section titles.
final class SettingsSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    /// Defines layout constants for the header view.
    enum Constants {
        static let titleLabelLeftPadding: CGFloat = 15
        static let titleLabelRightPadding: CGFloat = 0
    }
    
    // MARK: - Properties
    /// A static reusable identifier for the header view, leveraging the class name.
    static var reuseIdentifier: String {
        String(describing: self)
    }

    /// Title label used to display the section title.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "Title of the settings section".localized
        return label
    }()

    // MARK: - Initializers
    /// Initializes the section header view with a specific frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    /// Required initializer with a coder, not implemented for this class.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    /// Sets up the user interface of the header view.
    private func setupUI() {
        addSubview(titleLabel)
        setupConstraints()
    }
    
    /// Configures and activates the Auto Layout constraints for `titleLabel`.
    private func setupConstraints() {
        titleLabel.anchor(
            left: self.leftAnchor,
            horizontalLeftSpace: Constants.titleLabelLeftPadding,
            right: self.rightAnchor,
            horizontalRightSpace: Constants.titleLabelRightPadding,
            centerY: self.centerYAnchor
        )
    }
    
    // MARK: - Configuration
    /// Configures the header view with a given title.
    /// - Parameter title: The string to set as the title of the header view.
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - FontAdjustable
extension SettingsSectionHeaderView: FontAdjustable {
    
    /// Adjusts the font size of the title label based on the user's preferred content size category.
    /// This method is invoked when the content size category changes.
    func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: 18,
            maxFontSize: 24,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    /// Sets up an observer for changes in the user's preferred content size category.
    /// The font size of the title label is adjusted dynamically when these changes occur.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustFontsSize),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
}
