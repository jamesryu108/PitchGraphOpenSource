//
//  StatsSettingCollectionViewCell.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `StatsSettingCollectionViewCell` is a custom UICollectionViewCell used for displaying various settings options related to statistics.
/// It features an option image, a label, a checkmark image, and a set of colored circle views to indicate different states or categories.
final class StatsSettingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - ReuseIdentifier
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - Views
    
    /// ImageView for displaying an icon representing a particular option.
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Icon representing the setting option".localized
        return imageView
    }()
    
    /// Label for displaying the title or name associated with the option.
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.isAccessibilityElement = true
        label.accessibilityHint = "Title of the setting option".localized
        return label
    }()
    
    /// ImageView used as a checkmark indicator.
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Indicator for selected setting".localized
        return imageView
    }()
    
    /// StackView holding the primary components of the cell.
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [optionImageView, optionLabel, checkmarkImageView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    /// An array of circle views used to visually represent different states or categories.
    private let circleViews: [UIView] = (0..<4).map { _ in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4 // Radius for circular shape
        view.layer.masksToBounds = true
        view.backgroundColor = .label
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 8),
            view.heightAnchor.constraint(equalToConstant: 8)
        ])
        return view
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    
    /// Sets up the layout and arrangement of views within the cell.
    private func setupUI() {
        
        checkmarkImageView.anchor(
            width: 24,
            height: 24
        )
        
        optionImageView.anchor(
            width: 24,
            height: 24
        )
        
        let circlesStackView = UIStackView(arrangedSubviews: circleViews)
        circlesStackView.translatesAutoresizingMaskIntoConstraints = false
        circlesStackView.axis = .horizontal
        circlesStackView.distribution = .fillEqually
        circlesStackView.spacing = 8
        
        circlesStackView.anchor(
            width: 100,
            height: 24
        )
        
        // Update stackView to include circlesStackView
        stackView = UIStackView(arrangedSubviews: [optionImageView, optionLabel, circlesStackView, checkmarkImageView])
        
        contentView.addSubview(stackView)
        
        stackView.anchor(
            left: contentView.leftAnchor,
            horizontalLeftSpace: 8,
            right: contentView.rightAnchor,
            horizontalRightSpace: 8,
            centerY: contentView.centerYAnchor
        )
    }
    
    /// Configures the cell with specific settings option details.
    /// - Parameters:
    ///   - option: The option to be displayed in the cell.
    ///   - isSelected: A boolean indicating if the option is selected.
    ///   - selectedOptionIndex: The index of the selected option for color determination.
    func configureCell(with option: Option, isSelected: Bool, selectedOptionIndex: Int) {
        
        optionLabel.text = option.rawValue
        
        checkmarkImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "")
        
        optionImageView.image = switch option {
        case .option1: UIImage(systemName: "1.square.fill")
        case .option2: UIImage(systemName: "2.square.fill")
        case .option3: UIImage(systemName: "3.square.fill")
        case .option4: UIImage(systemName: "4.square.fill")
        }
        
        // Update circles colors based on selectedOptionIndex
        for (index, circleView) in circleViews.enumerated() {
            let color = getColor(forOptionIndex: selectedOptionIndex, circleIndex: index)
            circleView.backgroundColor = color
        }
    }
}

extension StatsSettingCollectionViewCell {
    /// Returns the appropriate color for a circle view based on the option index and circle index.
    /// - Parameters:
    ///   - optionIndex: The index of the selected option.
    ///   - circleIndex: The index of the circle view within the option.
    /// - Returns: The UIColor associated with the given indices.
    private func getColor(forOptionIndex optionIndex: Int, circleIndex: Int) -> UIColor {
        
        let colors: [[UIColor]] = [
            [.systemRed, .label, .systemYellow, .systemBlue], // Colors for option 0
            [.label, Option2ColorTheme.bronze, Option2ColorTheme.silver, Option2ColorTheme.gold], // Colors for option 1
            [.systemGray, .label, .systemYellow, .systemBlue], // Colors for option 2
            [.gray, .systemYellow, .systemBlue, .systemOrange]  // Colors for option 3
        ]
        
        if optionIndex >= 0 && optionIndex < colors.count && circleIndex >= 0 && circleIndex < colors[optionIndex].count {
            return colors[optionIndex][circleIndex]
        } else {
            return .label // Default color
        }
    }
}
