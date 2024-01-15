//
//  LegendView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class LegendView: UIView {
    // MARK: - Initialization
    var playerData: PlayerData
    init(frame: CGRect, playerData: PlayerData) {
        self.playerData = playerData
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        // You might want to handle this differently if your view is designed to be used from a storyboard or nib.
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup
    private func setupViews() {
        let minLegend = createLegendItem(color: .systemBlue, text: "\("Current ability:".localized)  \(playerData.currentAbility ?? 0)")
        let maxLegend = createLegendItem(color: .systemPink, text: "\("Potential ability:".localized)  \(Int(playerData.potentialAbility ?? "0") ?? 0)")
        let stackView = UIStackView(arrangedSubviews: [minLegend, maxLegend])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func createLegendItem(color: UIColor, text: String) -> UIView {
        let colorView = UIView()
        colorView.backgroundColor = color
        colorView.translatesAutoresizingMaskIntoConstraints = false
        let fixedDimension: CGFloat = 24
        colorView.widthAnchor.constraint(equalToConstant: fixedDimension).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: fixedDimension).isActive = true
        colorView.layer.cornerRadius = 12
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10) // Set font size to 10
        let stack = UIStackView(arrangedSubviews: [colorView, label])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }
}
