//
//  ResultCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `ResultCell` is a custom `UICollectionViewCell` implementing `FontAdjustable` and `ReusableCellConfiguring` protocols. It's designed to display player data in a collection view.
final class ResultCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {

    // MARK: - Constants
    /// Constants used for layout and styling within the cell.
    private enum Constants {
        static let flagImageLeftPadding: CGFloat = 10
        static let flagImageSize: CGFloat = 40
        static let stackViewLeftPadding: CGFloat = 10
        static let stackViewRightPadding: CGFloat = 10
        static let stackViewSpacing: CGFloat = 0
        static let contentViewCornerRadius: CGFloat = 10
        static let nameLabelMinFontSize: CGFloat = 11
        static let nameLabelMaxFontSize: CGFloat = 17
        static let nationalityLabelMinFontSize: CGFloat = 10
        static let nationalityLabelMaxFontSize: CGFloat = 16
        static let nameLabelDefaultText: String = "Click to pick a player".localized
        static let labelNumberOfLines: Int = 0
    }
    
    // MARK: - Static Properties
    /// A reuseIdentifier for cell reuse functionality within collection views.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    /// UIImageView for displaying the flag.
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "A national flag of a player".localized
        return imageView
    }()
    
    /// UILabel for displaying the player's name.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.nameLabelDefaultText
        label.textAlignment = .center
        label.numberOfLines = Constants.labelNumberOfLines
        label.isAccessibilityElement = true
        label.accessibilityHint = "A name of a player".localized
        return label
    }()
    
    /// UILabel for displaying the player's nationality and club.
    private let nationalityClubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = Constants.labelNumberOfLines
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "An abbreviation of player's country and name of the player's club".localized
        return label
    }()
    
    /// UIStackView for arranging the labels vertically.
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    /// Custom initializer for the cell.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupFontSizeAdjustmentObserver()
        adjustFontsSize()
    }
    
    /// Required initializer for decoding the cell from a nib or storyboard (not implemented).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Style Customization
    /// Applies styling to the cell's contentView.
    private func stylizeCell() {
        self.contentView.backgroundColor = .systemBackground
        self.contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        self.contentView.layer.masksToBounds = false
    }
    
    // MARK: - Cell Configuration
    /// Configures the cell by adding and setting up subviews and constraints.
    private func setupUI() {
        stylizeCell()
        setupLabels()
        setupStack()
        setupConstraints()
    }
    
    private func setupLabels() {
        contentView.addSubviews(flagImageView, stackView)
    }
    
    private func setupStack() {
        stackView.addArrangedSubviews(nameLabel, nationalityClubLabel)
    }
    
    private func setupConstraints() {
        // Constraints for flagImageView
        flagImageView.anchor(
            left: contentView.leftAnchor,
            horizontalLeftSpace: Constants.flagImageLeftPadding,
            width: Constants.flagImageSize,
            height: Constants.flagImageSize,
            centerY: contentView.centerYAnchor
        )
        
        // Constraints for stackView
        stackView.anchor(
            left: flagImageView.rightAnchor,
            horizontalLeftSpace: Constants.stackViewLeftPadding,
            right: contentView.rightAnchor,
            horizontalRightSpace: Constants.stackViewRightPadding,
            centerY: contentView.centerYAnchor
        )
    }
    
    // MARK: - Cell Data Configuration
    /// Configures the cell with player data.
    /// - Parameter result: `PlayerData` object used to configure the cell.
    func configure(with result: PlayerData) {
        flagImageView.image = UIImage(named: result.nationalities?[0] ?? "")
        nameLabel.text = result.name
        nationalityClubLabel.text = "\(result.nationalities?[0] ?? "N/A") / \(result.club ?? "Unattached".localized)"
    }
    
    // MARK: - Font Size Adjustment
    /// Adjusts the font size of labels based on accessibility settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: nameLabel,
            minFontSize: Constants.nameLabelMinFontSize,
            maxFontSize: Constants.nameLabelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: nationalityClubLabel,
            minFontSize: Constants.nationalityLabelMinFontSize,
            maxFontSize: Constants.nationalityLabelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    // MARK: - Font Size Adjustment Observer
    /// Sets up an observer for font size adjustments based on system settings.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
