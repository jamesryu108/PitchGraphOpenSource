//
//  EmptyLastSearchedCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-16.
//

import UIKit

// A cell used for displaying an empty favorite players message.
final class EmptyLastSearchedCollectionViewCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    
    private enum Constants {
        static let messageLabelFontSize: CGFloat = 18
        static let messageLabelFontWeight: UIFont.Weight = .bold
        static let messageLabelWidth: CGFloat = 300
        static let messageLabelHeight: CGFloat = 75
        static let labelMinFontSize: CGFloat = 14
        static let labelMaxFontSize: CGFloat = 22
        static let messageLabelText: String = "Please favorite some players to see something here".localized
        static let messageLabelTextAlignment: NSTextAlignment = .center
        static let messageLabelNumberOfLines: Int = 0
    }
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Elements
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = Constants.messageLabelTextAlignment
        label.numberOfLines = Constants.messageLabelNumberOfLines
        label.isAccessibilityElement = true
        label.accessibilityHint = "Message prompting to search for players".localized
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
    
    // MARK: - Private funcs
    
    private func setupUI() {
        self.addSubview(messageLabel)
        setupLabel()
        setupConstraints()
    }
    
    private func setupLabel() {
        messageLabel.text = Constants.messageLabelText
        messageLabel.font = UIFont.systemFont(ofSize: Constants.messageLabelFontSize, weight: Constants.messageLabelFontWeight)
    }
    
    private func setupConstraints() {
        messageLabel.anchor(
            width: Constants.messageLabelWidth,
            height: Constants.messageLabelHeight,
            centerX: self.centerXAnchor,
            centerY: self.centerYAnchor
        )
    }
    
    // MARK: - Font Adjustment
    
    func adjustFontsSize() {
        adjustFontSize(
            for: messageLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    // MARK: - Font Size Adjustment Observer
    
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
