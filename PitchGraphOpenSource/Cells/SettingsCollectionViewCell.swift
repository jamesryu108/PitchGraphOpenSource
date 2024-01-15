//
//  SettingsCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `SettingsCollectionViewCell` is a custom cell for collection views, designed to display settings options.
/// It includes an icon, a title, and an accessory image.
final class SettingsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    /// Constants used for layout and styling within the cell.
    private enum Constants {
        static let imageViewCornerRadius: CGFloat = 5
        static let cellCornerRadius: CGFloat = 8
        static let padding: CGFloat = 15
        static let imageDiameter: CGFloat = 40
        static let accessoryImageDiameter: CGFloat = 15
        static let separatorHeight: CGFloat = 1
    }

    private enum FontSize {
        static let minimum: CGFloat = 12
        static let maximum: CGFloat = 18
    }

    /// Reusable identifier for the cell.
    static let reuseIdentifier = String(describing: SettingsCollectionViewCell.self)
    
    // MARK: - UI Objects
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Icon representing the setting".localized
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "Title of the setting".localized
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Indicates more options available".localized
        return imageView
    }()
    
    /// View that acts as a separator at the bottom of the cell.
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    // MARK: - Initializers
    
    /// Initializes the cell with a specified frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    /// Required initializer with a coder, not implemented for this cell.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with the provided view model.
    /// Sets the background color of the icon, the image, and the title label's text.
    func configure(viewModel: SettingsViewModelData) {
        iconImageView.backgroundColor = viewModel.color
        iconImageView.image = UIImage(systemName: viewModel.image)
        titleLabel.text = viewModel.title
        
        backgroundColor = .systemBackground
        layer.cornerRadius = Constants.cellCornerRadius
    }

    // MARK: - Cell Configuration
    /// Sets up the views and their layout within the cell.
    /// Adds the iconImageView, titleLabel, accessoryImageView, and separatorView to the cell's content view.
    private func setupUI() {
        contentView.addSubviews(iconImageView, titleLabel, accessoryImageView, separatorView)
        setupConstraints()
    }

    /// Sets up the constraints for the UI components.
    /// Positions the icon, title, accessory image, and the separator within the cell.
    private func setupConstraints() {
        iconImageView.anchor(
            left: leftAnchor,
            horizontalLeftSpace: Constants.padding,
            width: Constants.imageDiameter,
            height: Constants.imageDiameter,
            centerY: centerYAnchor
        )
        
        titleLabel.anchor(
            left: iconImageView.rightAnchor,
            horizontalLeftSpace: Constants.padding,
            right: accessoryImageView.leftAnchor,
            horizontalRightSpace: Constants.padding,
            centerY: centerYAnchor
        )
        
        accessoryImageView.anchor(
            right: rightAnchor,
            horizontalRightSpace: Constants.padding,
            width: Constants.accessoryImageDiameter,
            height: Constants.accessoryImageDiameter,
            centerY: centerYAnchor
        )
        
        separatorView.anchor(
            bottom: bottomAnchor,
            verticalBottomSpace: 0,
            left: leftAnchor,
            horizontalLeftSpace: 0,
            right: rightAnchor,
            horizontalRightSpace: 0,
            height: 1
        )
    }

    // MARK: - Dynamic Type Support

    /// Adjusts the font size of the title label based on the user's preferred content size.
    /// Responds to changes in the device's content size category.
    @objc private func adjustFontsSize() {
        titleLabel.adjustFontSize(
            for: titleLabel,
            minFontSize: FontSize.minimum,
            maxFontSize: FontSize.maximum,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }

    /// Sets up an observer for font size adjustment notifications.
    /// Allows the cell to dynamically adjust its font size based on system settings.
    private func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustFontsSize),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
}
