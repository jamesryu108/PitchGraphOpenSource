//
//  PlayerSearchCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `PlayerSearchCollectionViewCell` is a custom `UICollectionViewCell` designed to display player information in a collection view. It conforms to `FontAdjustable` and `ReusableCellConfiguring` protocols.
final class PlayerSearchCollectionViewCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    /// Constants used for layout and styling within the cell.
    private enum Constants {
        static let padding: CGFloat = 8
        static let nameLabelFontSize: CGFloat = 14
        static let nationalityLabelFontSize: CGFloat = 13
        static let cornerRadius: CGFloat = 10
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: Float = 0.1
        static let shadowOffset: CGSize = CGSize(width: 0, height: 5)
        static let stackViewSpacing: CGFloat = 8
        static let minFontSizeNameLabel: CGFloat = 12
        static let maxFontSizeNameLabel: CGFloat = 18
        static let minFontSizeNationalityLabel: CGFloat = 11
        static let maxFontSizeNationalityLabel: CGFloat = 17
        static let imageCornerRadiusMultiplier: CGFloat = 0.5
    }
    
    // MARK: - Static Property
    /// A reuseIdentifier for cell reuse functionality within collection views.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    /// UIImageView for displaying the flag image.
    private let flagImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.accessibilityHint = "Shows the flag of the player here"
        return image
    }()
    
    /// UILabel for displaying the player's name.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "Shows the name of the player here."
        return label
    }()
    
    /// UILabel for displaying the player's nationality.
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "Shows the nationality of the player here."

        return label
    }()
    
    /// UIStackView for arranging the labels vertically.
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .fillProportionally
        return stackView
    }()

    // MARK: - Initializers
    /// Custom initializer for the cell.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    /// Required initializer for decoding the cell from a nib or storyboard (not implemented).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Style Customization
    /// Applies styling to the cell's contentView.
    private func stylizeCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.shadowOpacity = Constants.shadowOpacity
        self.layer.shadowRadius = Constants.shadowRadius
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.masksToBounds = false
    }
    
    // MARK: - Cell Configuration Method
    /// Configures the cell by adding and setting up subviews and constraints.
    private func setupUI() {
        contentView.addSubviews(flagImage, stackView)
        setupImage()
        setupStack()
        stylizeCell()
        setupConstraints()
    }
    
    /// Configures the cell with `PlayerData` and adjusts the cell's corner radius.
    /// - Parameters:
    ///   - playerData: The `PlayerData` object used to configure the cell.
    ///   - height: The height of the cell.
    func setupUI(playerData: PlayerData, height: CGFloat) {
        nameLabel.text = playerData.name ?? ""
        nationalityLabel.text = playerData.nationalities?[0] ?? ""
        self.contentView.layer.cornerRadius = height / Constants.cornerRadius
        if let nationality = UIImage(named: playerData.nationalities?[0] ?? "") {
            flagImage.image = nationality
        } else {
            flagImage.image = UIImage(systemName: "questionmark.circle.fill")
        }
    }
    
    private func setupConstraints() {
        flagImage.anchor(
            left: contentView.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            width: contentView.frame.height * Constants.imageCornerRadiusMultiplier,
            height: contentView.frame.height * Constants.imageCornerRadiusMultiplier,
            centerY: contentView.centerYAnchor
        )
        
        stackView.anchor(
            left: flagImage.rightAnchor,
            horizontalLeftSpace: Constants.padding,
            right: contentView.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: contentView.frame.height * Constants.imageCornerRadiusMultiplier,
            centerY: contentView.centerYAnchor
        )
    }

    /// Sets up the flag image view.
    private func setupImage() {
        // Constraints for flagImage
        flagImage.layer.cornerRadius = contentView.frame.height * Constants.imageCornerRadiusMultiplier / 2
    }
    
    // MARK: - Stack View Setup Method
    /// Sets up the stack view containing the name and nationality labels.
    private func setupStack() {
        stackView.addArrangedSubviews(nameLabel, nationalityLabel)
    }
    
    // MARK: - Font Size Adjustment Method
    /// Adjusts the font size of labels based on accessibility settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: nameLabel,
            minFontSize: Constants.minFontSizeNameLabel,
            maxFontSize: Constants.maxFontSizeNameLabel,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: nationalityLabel,
            minFontSize: Constants.minFontSizeNationalityLabel,
            maxFontSize: Constants.maxFontSizeNationalityLabel,
            forTextStyle: .body,
            isBlackWeight: false
        )
    }
    
    // MARK: - Font Size Adjustment Observer Setup Method
    /// Sets up an observer for font size adjustments based on system settings.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
