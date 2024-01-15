//
//  AttributeCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// A cell used for displaying player attributes.
final class AttributeCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelMinFontSize: CGFloat = 8
        static let labelMaxFontSize: CGFloat = 12
        static let attributeMinFontSize: CGFloat = 12
        static let attributeMaxFontSize: CGFloat = 18
        static let separatorViewWidth: CGFloat = 0.5
        static let titleLabelHeightMultiplier: CGFloat = 0.25
        static let attributeLabelHeightMultiplier: CGFloat = 0.30
        static let padding: CGFloat = 8
        static let separatorViewPadding: CGFloat = 0
    }
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is an attribute title".localized
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is an attribute label".localized

        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is an unit label".localized
        return label
    }()
    
    // Separator view
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupFontSizeAdjustmentObserver()
        adjustFontsSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    
    private func setupUI() {
        self.contentView.addSubviews(titleLabel, attributeLabel, unitLabel, separatorView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.anchor(
            top: self.topAnchor,
            verticalTopSpace: Constants.padding,
            width: self.frame.width,
            height: self.contentView.frame.height * Constants.titleLabelHeightMultiplier,
            centerX: self.centerXAnchor
        )
        
        attributeLabel.anchor(
            top: titleLabel.bottomAnchor,
            verticalTopSpace: Constants.padding,
            width: self.frame.width,
            height: self.contentView.frame.height * Constants.attributeLabelHeightMultiplier,
            centerX: self.centerXAnchor
        )
        
        unitLabel.anchor(
            top: attributeLabel.bottomAnchor,
            verticalTopSpace: Constants.padding,
            bottom: self.bottomAnchor,
            verticalBottomSpace: Constants.padding,
            width: self.frame.width,
            centerX: self.centerXAnchor
        )
        
        separatorView.anchor(
            top: self.topAnchor,
            verticalTopSpace: Constants.separatorViewPadding,
            bottom: self.bottomAnchor,
            verticalBottomSpace: Constants.separatorViewPadding,
            right: self.rightAnchor,
            horizontalRightSpace: Constants.separatorViewPadding,
            width: Constants.separatorViewWidth
        )
    }
        
    /// Configure the cell with a player attribute.
    /// - Parameter attribute: The player attribute to display.
    func configure(with attribute: PlayerAttribute) {
        titleLabel.text = attribute.title.localized
        attributeLabel.text = attribute.value
        unitLabel.text = attribute.unit?.localized ?? ""
    }

    // MARK: - Font Adjustment
    
    /// Adjusts the font sizes based on dynamic type settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: false
        )
        adjustFontSize(
            for: attributeLabel,
            minFontSize: Constants.attributeMinFontSize,
            maxFontSize: Constants.attributeMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: unitLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: false
        )
    }
    
    // MARK: - Font Size Adjustment Observer
    
    /// Sets up an observer to adjust font sizes when the content size category changes.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}

