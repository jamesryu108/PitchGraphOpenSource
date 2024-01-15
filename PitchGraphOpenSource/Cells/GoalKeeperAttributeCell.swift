//
//  GoalKeeperAttributeCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `GoalKeeperAttributeCell` is a custom `UICollectionViewCell` designed to display goalkeeper attributes in a collection view. It conforms to `FontAdjustable` and `ReusableCellConfiguring` protocols.
final class GoalKeeperAttributeCell: UICollectionViewCell, FontAdjustable, ReusableCellConfiguring {
    
    // MARK: - Constants
    /// Constants used for layout and styling within the cell.
    enum Constants {
        static let nameLabelWidthMultiplier: CGFloat = 0.75
        static let scoreLabelWidthMultiplier: CGFloat = 0.25
        static let minFontSizeNameLabel: CGFloat = 11
        static let maxFontSizeNameLabel: CGFloat = 17
        static let minFontSizeScoreLabel: CGFloat = 13
        static let maxFontSizeScoreLabel: CGFloat = 19
    }
    
    // MARK: - Static Property
    /// A reuseIdentifier for cell reuse functionality within collection views.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Components
    /// UILabels for displaying the attribute's name and score.
    var nameLabel: AttributeLabel!
    var scoreLabel: AttributeLabel!
    
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
    
    // MARK: - Cell Configuration Method
    /// Sets up the user interface of the cell.
    private func setupUI() {
        // Creating and configuring nameLabel and scoreLabel with specific frames based on cell size and constants.
        nameLabel = AttributeLabel(frame: CGRect(x: 0, y: 0, width: self.frame.width * Constants.nameLabelWidthMultiplier, height: self.frame.height))
        scoreLabel = AttributeLabel(frame: CGRect(x: nameLabel.frame.maxX, y: 0, width: self.frame.width * Constants.scoreLabelWidthMultiplier, height: self.frame.height))
        
        nameLabel.textAlignment = .natural
        scoreLabel.textAlignment = .right
        
        // Adding nameLabel and scoreLabel to the cell's contentView.
        self.contentView.addSubviews(nameLabel, scoreLabel)
    }
    
    /// Configures the cell with a `GoalKeeperAttribute` object.
    /// - Parameters:
    ///   - attribute: The `GoalKeeperAttribute` object used to configure the cell.
    ///   - index: The index of the cell in the collection view.
    func configure(
        with attribute: GoalKeeperAttribute,
        index: Int,
        option: Int
    ) {
        nameLabel.text = attribute.name.capitalized.localized
        scoreLabel.text = "\(attribute.score)"
        
        // Alternating background color for even and odd cells.
        if index % 2 != 0 {
            nameLabel.backgroundColor = .systemBackground
            scoreLabel.backgroundColor = .systemBackground
        } else {
            nameLabel.backgroundColor = .systemGray6
            scoreLabel.backgroundColor = .systemGray6
        }
        scoreLabel.isAccessibilityElement = true
        scoreLabel.accessibilityHint = "The score is out of 20".localized
        // Changing scoreLabel text color based on the attribute score.
        scoreLabel.textColor = colorForScore(attribute.score, option: option)
    }
    
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
    
    // MARK: - Font Size Adjustment Method
    /// Adjusts the font size of labels based on accessibility settings.
    func adjustFontsSize() {
        adjustFontSize(
            for: nameLabel,
            minFontSize: Constants.minFontSizeNameLabel,
            maxFontSize: Constants.maxFontSizeNameLabel,
            forTextStyle: .body,
            isBlackWeight: false
        )
        adjustFontSize(
            for: scoreLabel,
            minFontSize: Constants.minFontSizeScoreLabel,
            maxFontSize: Constants.maxFontSizeScoreLabel,
            forTextStyle: .body,
            isBlackWeight: true
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
