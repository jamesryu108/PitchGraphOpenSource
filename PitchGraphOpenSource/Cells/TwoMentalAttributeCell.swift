//
//  TwoMentalAttributeCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// A cell used for displaying two mental attributes of a player.
final class TwoMentalAttributeCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelMinFontSize: CGFloat = 10
        static let labelMaxFontSize: CGFloat = 20
        static let leftPadding: CGFloat = 8
        static let rightPadding: CGFloat = 8
        static let widthMultiplier: CGFloat = 0.25
        static let backgroundColorEven: UIColor = .systemBackground
        static let backgroundColorOdd: UIColor = .systemGray6
    }
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Elements
    
    private let player1ScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.isAccessibilityElement = true
        label.accessibilityHint = "Displays the first player's mental score".localized
        return label
    }()
    
    private let attributeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityHint = "Displays the name of the mental attribute".localized
        return label
    }()
    
    private let player2ScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.isAccessibilityElement = true
        label.accessibilityHint = "Displays the second player's mental score".localized
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

        contentView.addSubviews(player1ScoreLabel, attributeNameLabel, player2ScoreLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        player1ScoreLabel.anchor(
            left: contentView.leftAnchor,
            horizontalLeftSpace: Constants.leftPadding,
            width: contentView.frame.width * Constants.widthMultiplier,
            centerY: contentView.centerYAnchor
        )

        attributeNameLabel.anchor(
            left: player1ScoreLabel.rightAnchor,
            horizontalLeftSpace: Constants.leftPadding,
            right: player2ScoreLabel.leftAnchor,
            horizontalRightSpace: Constants.rightPadding,
            centerY: contentView.centerYAnchor
        )
        
        player2ScoreLabel.anchor(
            right: contentView.rightAnchor,
            horizontalRightSpace: Constants.rightPadding,
            width: contentView.frame.width * Constants.widthMultiplier,
            centerY: contentView.centerYAnchor
        )
    }
        
    /// Configures the cell with player scores and an attribute name.
    /// - Parameters:
    ///   - player1Score: The score of player 1.
    ///   - attributeName: The name of the attribute.
    ///   - player2Score: The score of player 2.
    ///   - index: The index of the cell.
    func configure(player1Score: Int, attributeName: String, player2Score: Int, index: Int, option: Int) {
        player1ScoreLabel.text = "\(player1Score)"
        attributeNameLabel.text = attributeName.localized
        player2ScoreLabel.text = "\(player2Score)"
        
        let isEvenRow = index % 2 != 0

        let backgroundColor = isEvenRow ? Constants.backgroundColorEven : Constants.backgroundColorOdd
        
        player1ScoreLabel.backgroundColor = backgroundColor
        attributeNameLabel.backgroundColor = backgroundColor
        player2ScoreLabel.backgroundColor = backgroundColor
        contentView.backgroundColor = backgroundColor

        player1ScoreLabel.textColor = colorForScore(player1Score, option: option)
        player2ScoreLabel.textColor = colorForScore(player2Score, option: option)
    }

    // MARK: - Text Color Calculation
    
    private func colorForScore(_ score: Int, option: Int) -> UIColor {
        switch option {
        case 0:
            switch score {
            case 0...9: return .systemRed
            case 10...14: return .label
            case 15...17: return .systemYellow
            case 18...20: return .systemBlue
            default: return .label
            }
        case 1:
            switch score {
            case 0...9: return .label
            case 10...14: return Option2ColorTheme.bronze
            case 15...17: return Option2ColorTheme.silver
            case 18...20: return Option2ColorTheme.gold
            default: return .label
            }
        case 2:
            switch score {
            case 0...9: return .systemGray
            case 10...14: return .label
            case 15...17: return .systemYellow
            case 18...20: return .systemBlue
            default: return .label
            }
        case 3:
            switch score {
            case 0...9: return .gray
            case 10...14: return .systemYellow
            case 15...17: return .systemBlue
            case 18...20: return .systemOrange
            default: return .label
            }
        default:
            return .label
        }
    }
    
    // MARK: - Font Adjustment
    
    /// Adjusts the font sizes based on dynamic type settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: player1ScoreLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: attributeNameLabel,
            minFontSize: Constants.labelMinFontSize,
            maxFontSize: Constants.labelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: false
        )
        adjustFontSize(
            for: player2ScoreLabel,
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

