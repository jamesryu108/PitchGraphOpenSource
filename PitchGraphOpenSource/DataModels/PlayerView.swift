//
//  PlayerView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

final class PlayerView: UIView {
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20 // For a circular shape
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass.circle.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Click to pick a player".localized
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let twoPlayerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Closure to be called when the close button is tapped
    var onClose: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        setupUI()
        setupFontSizeAdjustmentObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func stylizeCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.masksToBounds = false
    }
    
    @objc private func closeButtonTapped() {
        onClose?()
    }
    
    private func setupUI() {
        stylizeCell()
        setupConstraints()
        adjustFontsSize()
    }
    
    private func setupConstraints() {
    
        self.addSubview(twoPlayerStack)
        self.addSubview(flagImageView)
        twoPlayerStack.addArrangedSubview(nameLabel)
        twoPlayerStack.addArrangedSubview(countryLabel)

        flagImageView.anchor(
            left: self.leftAnchor,
            horizontalLeftSpace: 16,
            width: 40,
            height: 40,
            centerY: self.centerYAnchor
        )
        
        twoPlayerStack.anchor(
            left: self.leftAnchor,
            horizontalLeftSpace: 12,
            right: self.rightAnchor,
            horizontalRightSpace: 12,
            centerX: self.centerXAnchor,
            centerY: self.centerYAnchor
        )
        
        self.addSubview(closeButton)

        closeButton.anchor(
            top: self.topAnchor,
            verticalTopSpace: 8,
            right: self.rightAnchor,
            horizontalRightSpace: 8,
            width: 24,
            height: 24
        )
    }
    
    func configureWith(player: PlayerData?) {
        nameLabel.text = player?.name ?? "Click to pick a player".localized
        countryLabel.text = "\(player?.nationalities?[0] ?? "N/A") | \(player?.club ?? "N/A")"
        flagImageView.image = player == nil ? UIImage(systemName: "magnifyingglass.circle.fill") : UIImage(named: player?.nationalities?[0] ?? "")
        closeButton.isHidden = player == nil
    }
}

extension PlayerView: FontAdjustable {
    func adjustFontsSize() {
        adjustFontSize(for: nameLabel, minFontSize: 18, maxFontSize: 24, forTextStyle: .body, isBlackWeight: true)
        adjustFontSize(for: countryLabel, minFontSize: 18, maxFontSize: 24, forTextStyle: .body, isBlackWeight: true)
    }
    
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
