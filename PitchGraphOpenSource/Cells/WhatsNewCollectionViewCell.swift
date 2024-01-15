//
//  WhatsNewCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `WhatsNewCollectionViewCell` is responsible for displaying individual items in the 'What's New' collection view.
/// It includes a title label to display the update information and a separator for visual separation between items.
final class WhatsNewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants

    /// Constants used for layout and styling within the cell.
    enum Constants {
        static let layerCornerRadius: CGFloat = 8
        static let padding: CGFloat = 0
        static let fontMinimumSize: CGFloat = 18
        static let fontMaximumSize: CGFloat = 24
        static let separatorWidth: CGFloat = 1
    }
    
    // MARK: - Properties

    /// A static reusable identifier for the cell.
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    /// A label for the title within the cell, used to display the update text.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        label.accessibilityHint = "Details about the latest update".localized
        return label
    }()
    
    /// A view that acts as a separator line at the bottom of the cell.
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray // Color for the separator line
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration

    /// Configures the cell with a given text.
    /// - Parameter text: The text to display in the cell.
    func configure(text: String) {
        titleLabel.text = text
        self.backgroundColor = .systemBackground // Sets the default background color
    }

    /// Sets up the subviews and their layout constraints within the cell.
    private func setupUI() {
        addSubviews(titleLabel, separatorView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.anchor(
            top: topAnchor,
            verticalTopSpace: Constants.padding,
            bottom: bottomAnchor,
            verticalBottomSpace: Constants.padding,
            left: leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: rightAnchor,
            horizontalRightSpace: Constants.padding
        )
        
        separatorView.anchor(
            bottom: bottomAnchor,
            verticalBottomSpace: Constants.padding,
            left: leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.separatorWidth
        )
    }
}

// MARK: - FontAdjustable

extension WhatsNewCollectionViewCell: FontAdjustable {
    
    /// Responds to changes in the user's preferred text size by adjusting the font size of the title label.
    @objc func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: Constants.fontMinimumSize,
            maxFontSize: Constants.fontMaximumSize,
            forTextStyle: .body,
            isBlackWeight: true // Determines if the font weight is black or not
        )
    }
    
    /// Sets up an observer to listen for notifications when the user's preferred text size changes.
    /// This ensures that the cell adjusts its font size in response to the user's settings.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustFontsSize),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
}
