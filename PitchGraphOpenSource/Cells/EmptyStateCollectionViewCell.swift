//
//  EmptyStateCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

// A cell used to display an empty state message.
final class EmptyStateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    // MARK: - UI Elements
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please search for players".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is an instruction for users to remind them to use the search bar to find players that they are looking for. Double-click on a search bar at the top to start searching.".localized
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    
    private func configure() {
        contentView.addSubview(messageLabel)
        messageLabel.anchor(
            left: contentView.leftAnchor,
            horizontalLeftSpace: 8,
            right: contentView.rightAnchor,
            horizontalRightSpace: 8,
            centerX: contentView.centerXAnchor,
            centerY: contentView.centerYAnchor
        )
    }
}

// MARK: - FontAdjustable Extension

extension EmptyStateCollectionViewCell: FontAdjustable {
    
    // MARK: - Font Adjustment
    
    func adjustFontsSize() {
        adjustFontSize(for: messageLabel, minFontSize: 25, maxFontSize: 31, forTextStyle: .body, isBlackWeight: true)
    }
    
    // MARK: - Font Size Adjustment Observer
    
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
