//
//  ComparisonCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// A cell used for displaying player comparison data.
final class ComparisonCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelLeftPadding: CGFloat = 10
        static let labelRightPadding: CGFloat = 10
        static let parameterLabelWidthMultiplier: CGFloat = 0.3
        static let labelMinFontSize: CGFloat = 10
        static let labelMaxFontSize: CGFloat = 16
        static let backgroundColor: UIColor = .systemGray6
    }
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Elements
    
    private let parameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "A name of a player".localized
        return label
    }()
    
    private let leftValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "Stat of a first player".localized
        return label
    }()
    
    private let rightValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "Stat of a second player".localized
        return label
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
        
        parameterLabel.textAlignment = .center
        
        self.addSubviews(leftValueLabel, parameterLabel, rightValueLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        leftValueLabel.anchor(
            left: self.leftAnchor,
            horizontalLeftSpace: Constants.labelLeftPadding,
            height: self.contentView.frame.height,
            centerY: self.contentView.centerYAnchor
        )
        
        parameterLabel.anchor(
            left: leftValueLabel.rightAnchor,
            horizontalLeftSpace: 0,
            width: self.contentView.frame.width * Constants.parameterLabelWidthMultiplier,
            height: self.contentView.frame.height,
            centerX: self.centerXAnchor,
            centerY: self.centerYAnchor
        )
        
        rightValueLabel.anchor(
            left: parameterLabel.rightAnchor,
            horizontalLeftSpace: 0,
            right: self.rightAnchor,
            horizontalRightSpace: Constants.labelRightPadding,
            height: self.contentView.frame.height,
            centerY: self.centerYAnchor
        )
    }
        
    /// Sets up the cell with player comparison data and indexPath.
    /// - Parameters:
    ///   - data: The player comparison data.
    ///   - indexPath: The index path of the cell.
    func setupCell(with data: PlayerComparison, indexPath: Int) {
        parameterLabel.text = data.parameter
        leftValueLabel.text = data.leftValue
        rightValueLabel.text = data.rightValue

        if indexPath % 2 != 0 {
            parameterLabel.backgroundColor = Constants.backgroundColor
            leftValueLabel.backgroundColor = Constants.backgroundColor
            rightValueLabel.backgroundColor = Constants.backgroundColor
        }
    }
    
    // MARK: - Font Adjustment
    
    /// Adjusts the font sizes based on dynamic type settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: parameterLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: false
        )
        adjustFontSize(
            for: leftValueLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: rightValueLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
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
