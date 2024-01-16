//
//  LastSearchedCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-16.
//

import UIKit

final class LastSearchCollectionViewCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    private enum Constants {
        static let padding: CGFloat = 8
        static let stackViewSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 5
        static let shadowOffset: CGSize = CGSize(width: 0, height: 5)
        static let imageCornerRadiusMultiplier: CGFloat = 0.5
        static let stackViewHeightMultiplier: CGFloat = 0.5
        static let labelMinFontSize: CGFloat = 18
        static let labelMaxFontSize: CGFloat = 24
        static let labelTextAlignment: NSTextAlignment = .center
    }
    
    // MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Elements
    private let flagImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isAccessibilityElement = true
        image.accessibilityHint = "Flag representing the player's nationality".localized
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = Constants.labelTextAlignment
        label.isAccessibilityElement = true
        label.accessibilityHint = "Name of the player".localized
        return label
    }()
    
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = Constants.labelTextAlignment
        label.isAccessibilityElement = true
        label.accessibilityHint = "Nationality of the player".localized
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .fillProportionally
        return stackView
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
        contentView.addSubviews(flagImage, stackView)
        
        setupImage()
        setupStack()
        stylizeCell()
        setupConstraints()
    }
    
    private func setupImage() {
        flagImage.layer.cornerRadius = contentView.frame.height * Constants.imageCornerRadiusMultiplier / 2
    }
    
    private func setupStack() {
        stackView.addArrangedSubviews(nameLabel, nationalityLabel)
    }
    
    private func stylizeCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.shadowOpacity = Constants.shadowOpacity
        self.layer.shadowRadius = Constants.shadowRadius
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.masksToBounds = false
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
            height: contentView.frame.height * Constants.stackViewHeightMultiplier,
            centerY: contentView.centerYAnchor
        )
    }
    
    // MARK: - UI Configuration
    func configure(playerData: LastSearchedPlayerInfo, height: CGFloat) {
        nameLabel.text = playerData.name
        nationalityLabel.text = playerData.nationality ?? ""
        self.contentView.layer.cornerRadius = height / Constants.cornerRadius
        if let nationality = UIImage(named: playerData.nationality ?? "") {
            flagImage.image = nationality
        } else {
            flagImage.image = UIImage(systemName: "questionmark.circle.fill")
        }
    }
    
    // MARK: - Font Adjustment
    func adjustFontsSize() {
        adjustFontSize(
            for: nameLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: nationalityLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: false
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
