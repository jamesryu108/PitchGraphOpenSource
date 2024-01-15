//
//  CloudStatusCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class CloudStatusCell: UICollectionViewCell {
    
    // MARK: - Constants
    /// Constants used for defining the cell's layout and appearance.
    enum Constants {
        static let topImagePadding: CGFloat = 13
        static let iconImageDiameter: CGFloat = 24
        static let statusIndicatorDiameter: CGFloat = 20
        static let titleLabelPadding: CGFloat = 8
        static let iconImageLeftPadding: CGFloat = 0
        static let statusHorizontalPadding: CGFloat = 0
        static let statusVerticalPadding: CGFloat = 4
        static let separatorWidth: CGFloat = 1
        static let separatorViewPadding: CGFloat = 0
        static let animationTimer: CGFloat = 0.25
        
        enum ContentSizeMultiplier {
            static let extraSmall: CGFloat = 0.8
            static let small: CGFloat = 0.9
            static let medium: CGFloat = 1.0
            static let large: CGFloat = 1.1
            static let extraLargeAndAbove: CGFloat = 1.2
            static let darkModeAdjustment: CGFloat = 0.1
        }
    }
    
    /// Constants used for defining the font size of `textLabel` and `statusLabel`
    enum FontSize {
        static let statusLabelMinFont: CGFloat = 12
        static let statusLabelMaxFont: CGFloat = 18
        static let textLabelMinFont: CGFloat = 18
        static let textLabelMaxFont: CGFloat = 24
    }
    
    // MARK: - Properties
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    /// Constraints used for dynamically adjusting the size of the icon image view.
    private var iconImageViewWidthConstraint: NSLayoutConstraint?
    private var iconImageViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI elements
    /// Image view to display an icon representing the cloud status.
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Icon representing the cloud status".localized
        return imageView
    }()
    
    /// Label for displaying the title or name of the cloud status.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "Title of the cloud status".localized
        return label
    }()
    
    /// Label for displaying additional information about the cloud status.
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "Description of the cloud status".localized
        return label
    }()
    
    /// Image view to indicate the current status using symbols (e.g., checkmark or cross).
    private let statusIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    /// View that acts as a separator at the bottom of the cell.
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray  // Set your preferred color
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
        setupImageSizeAdjustmentObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    /// Sets up the views and their layout within the cell.
    private func setupUI() {
        contentView.addSubviews(iconImageView, titleLabel, statusLabel, statusIndicator, separatorView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Constraints for iconImageView
        iconImageView.anchor(
            top: contentView.topAnchor,
            verticalTopSpace: Constants.topImagePadding,
            left: contentView.leftAnchor,
            horizontalLeftSpace: Constants.iconImageLeftPadding
        )
        
        let initialSize: CGFloat = Constants.iconImageDiameter
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: initialSize)
        iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: initialSize)
        
        iconImageViewWidthConstraint?.isActive = true
        iconImageViewHeightConstraint?.isActive = true
        
        // Constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.titleLabelPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusIndicator.leadingAnchor, constant: -Constants.titleLabelPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])

        statusLabel.anchor(
            top: titleLabel.bottomAnchor,
            verticalTopSpace: Constants.statusVerticalPadding,
            left: titleLabel.leftAnchor,
            horizontalLeftSpace: Constants.statusHorizontalPadding,
            right: titleLabel.rightAnchor,
            horizontalRightSpace: Constants.statusHorizontalPadding
        )
        
        statusIndicator.anchor(
            right: contentView.rightAnchor,
            horizontalRightSpace: Constants.statusHorizontalPadding,
            width: Constants.statusIndicatorDiameter,
            height: Constants.statusIndicatorDiameter,
            centerY: contentView.centerYAnchor
        )
        
        // Ensure the contentView's bottom is greater than or equal to the bottom of statusLabel
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: statusLabel.bottomAnchor).isActive = true
                
        separatorView.anchor(
            bottom: contentView.bottomAnchor,
            verticalBottomSpace: Constants.separatorViewPadding,
            left: contentView.leftAnchor,
            horizontalLeftSpace: Constants.separatorViewPadding,
            right: contentView.rightAnchor,
            horizontalRightSpace: Constants.separatorViewPadding,
            height: Constants.separatorWidth
        )
    }
    
    /// Configures the cell with the provided cloud status details.
    func configure(with status: CloudStatusDetails) {
        
        titleLabel.text = status.name
        iconImageView.image = UIImage(systemName: status.imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        statusLabel.text = status.status

        if status.cloudStatus == .available {
            statusIndicator.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            statusIndicator.isHidden = false
        } else {
            // For other statuses, you might want to check some other condition
            statusIndicator.image = UIImage(systemName: "x.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            statusIndicator.isHidden = false
        }
    }
    
    // MARK: - Dynamic Type Support
    /// Adjusts the image view size based on the user's preferred content size category.
    @objc func adjustImageViewSize() {
        
        let category = UIApplication.shared.preferredContentSizeCategory
        let userInterfaceStyle = traitCollection.userInterfaceStyle // Optional: Adjust for dark/light mode if needed
        let sizeMultiplier = multiplierForContentSizeCategory(category, userInterfaceStyle: userInterfaceStyle)
        
        let newHeight = Constants.iconImageDiameter * sizeMultiplier.height
        let newWidth = Constants.iconImageDiameter * sizeMultiplier.width
        
        iconImageViewWidthConstraint?.constant = newHeight
        iconImageViewHeightConstraint?.constant = newWidth
        
        UIView.animate(withDuration: Constants.animationTimer) {
            self.layoutIfNeeded()
        }
    }
    
    /// Calculates the size multiplier based on content size category and interface style.
    private func multiplierForContentSizeCategory(
        _ category: UIContentSizeCategory,
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> (width: CGFloat, height: CGFloat) {
        
        var multiplier: CGFloat = Constants.ContentSizeMultiplier.medium // Default multiplier
        
        switch category {
        case .extraSmall:
            multiplier = Constants.ContentSizeMultiplier.extraSmall
        case .small:
            multiplier = Constants.ContentSizeMultiplier.small
        case .medium:
            multiplier = Constants.ContentSizeMultiplier.medium
        case .large:
            multiplier = Constants.ContentSizeMultiplier.large
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge:
            multiplier = Constants.ContentSizeMultiplier.extraLargeAndAbove
        default:
            multiplier = Constants.ContentSizeMultiplier.medium
        }
        
        if userInterfaceStyle == .dark {
            multiplier += Constants.ContentSizeMultiplier.darkModeAdjustment
        }
        
        return (multiplier, multiplier)
    }
}

// MARK: - Font and Image Size Adjustment
/// Sets up observers for dynamic font size and image size adjustments.
extension CloudStatusCell: FontAdjustable {
    func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: FontSize.textLabelMinFont,
            maxFontSize: FontSize.textLabelMaxFont,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: statusLabel,
            minFontSize: FontSize.statusLabelMinFont,
            maxFontSize: FontSize.statusLabelMaxFont,
            forTextStyle: .body,
            isBlackWeight: false
        )
    }
    
    
    func setupImageSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(adjustAllCells),
                                                   name: UIContentSizeCategory.didChangeNotification,
                                                   object: nil)
    }
    
    @objc private func adjustAllCells() {
        adjustImageViewSize()
    }
    
    /// Sets up observers for dynamic font size and image size adjustments.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
