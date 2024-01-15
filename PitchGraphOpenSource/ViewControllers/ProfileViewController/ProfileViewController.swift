//
//  ProfileViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

// MARK: - ProfileViewController

/// `ProfileViewController` displays the profile information of a soccer player.
final class ProfileViewController: UIViewController {
    
    // MARK: - Constants

    /// Constants used for layout configuration.
    private enum Constants {
        static let padding: CGFloat = 8
        static let profileImageCornerRadius: CGFloat = 40
        static let profileImageTopPadding: CGFloat = 20
        static let profileImageSize: CGFloat = 80
        static let nationalityLabelTopPadding: CGFloat = 10
        static let nationalityLabelHeight: CGFloat = 32
        static let collectionViewTopPadding: CGFloat = 0
        static let collectionViewHeight: CGFloat = 100
        static let progressTitleLabelTopPadding: CGFloat = 8
        static let progressTitleLabelHeight: CGFloat = 32
        static let progressBarTopPadding: CGFloat = 20
        static let progressBarHeight: CGFloat = 20
        static let legendViewTopPadding: CGFloat = 8
        static let legendViewHeight: CGFloat = 50
        static let progressTitleLabelMinFontSize: CGFloat = 18
        static let progressTitleLabelMaxFontSize: CGFloat = 30
        static let nationalityLabelMinFontSize: CGFloat = 14
        static let nationalityLabelMaxFontSize: CGFloat = 26
    }
    
    enum Section {
        case main
    }
    
    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.profileImageCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityHint = "Profile image of the player".localized
        return imageView
    }()
    
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "Nationality of the player".localized
        return label
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let viewModel: ProfileViewModel
    private var playerData: PlayerData
    
    private let progressBar: CustomProgressBar = {
        let bar = CustomProgressBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.isAccessibilityElement = true
        bar.accessibilityHint = "Visual representation of the player's progress".localized
        return bar
    }()
    
    private let progressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current/Potential Ability".localized
        label.isAccessibilityElement = true
        label.accessibilityHint = "Indicator of the player's current and potential ability".localized
        return label
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PlayerAttribute>!
    private var playerCell: [PlayerAttribute] = []
    
    // MARK: - Initializers

    /// Initializes the `ProfileViewController` with player data.
    init(playerData: PlayerData, viewModel: ProfileViewModel) {
        self.playerData = playerData
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    /// Called after the view controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData(playerData: viewModel.createPlayerAttribute(playerData: playerData))
        setupUI()
        configureDataSource()
        setupFontSizeAdjustmentObserver()
    }
    
    // MARK: - UI Setup Methods

    /// Sets up the user interface for the profile view controller.
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        setupProfileInfo()
        setupCV()
        setupProgressBar()
        adjustFontsSize()
    }
    
    /// Sets up profile image and nationality label.
    private func setupProfileInfo() {
        self.view.addSubview(profileImageView)
        self.view.addSubview(nationalityLabel)
        
        profileImageView.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: Constants.profileImageTopPadding,
            width: Constants.profileImageSize,
            height: Constants.profileImageSize,
            centerX: self.view.centerXAnchor
        )
        
        if let nationality = UIImage(named: playerData.nationalities?[0] ?? "") {
            profileImageView.image = nationality
        } else {
            profileImageView.image = UIImage(systemName: "questionmark.circle.fill")
        }
        
        nationalityLabel.anchor(
            top: profileImageView.bottomAnchor,
            verticalTopSpace: Constants.nationalityLabelTopPadding,
            left: self.view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: self.view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.nationalityLabelHeight,
            centerX: self.view.centerXAnchor
        )
        
        nationalityLabel.text = playerData.nationalities?[0] ?? "N/A"
    }
    
    /// Sets up the collection view for player attributes.
    private func setupCV() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(AttributeCell.self, forCellWithReuseIdentifier: AttributeCell.reuseIdentifier)
        
        collectionView.anchor(
            top: nationalityLabel.bottomAnchor,
            verticalTopSpace: Constants.collectionViewTopPadding,
            left: self.view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: self.view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.collectionViewHeight
        )
    }
    
    /// Sets up the progress bar and its title label.
    private func setupProgressBar() {
        self.view.addSubview(progressTitleLabel)
        progressTitleLabel.anchor(
            top: collectionView.bottomAnchor,
            verticalTopSpace: Constants.progressTitleLabelTopPadding,
            left: self.view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: self.view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.progressTitleLabelHeight
        )
        
        self.view.addSubview(progressBar)
        progressBar.anchor(
            top: progressTitleLabel.bottomAnchor,
            verticalTopSpace: Constants.progressBarTopPadding,
            left: self.view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: self.view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.progressBarHeight
        )
        
        progressBar.setProgress(
            minValue: CGFloat(Int(playerData.currentAbility ?? 0)),
            maxValue: CGFloat(Int(playerData.potentialAbility ?? "0") ?? 0)
        )
        
        let legend = LegendView(frame: .zero, playerData: playerData)
        legend.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(legend)
        
        legend.anchor(
            top: progressBar.bottomAnchor,
            verticalTopSpace: Constants.legendViewTopPadding,
            left: self.view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: self.view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.legendViewHeight
        )
    }
    
    /// Configures the data source for the collection view.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PlayerAttribute>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeCell.reuseIdentifier, for: indexPath) as? AttributeCell else {
                fatalError("AttributeCell does not exist")
            }
            self.playerCell = self.viewModel.createPlayerAttribute(playerData: self.playerData)
            cell.configure(with: self.playerCell[indexPath.row])
            return cell
        })
    }
    
    /// Updates the collection view data.
    private func updateData(playerData: [PlayerAttribute]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlayerAttribute>()
        snapshot.appendSections([.main])
        snapshot.appendItems(playerData)
        DispatchQueue.main.async { [self] in
            self.dataSource.apply(snapshot, animatingDifferences: true)
            playerCell = playerData
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    /// Specifies the size for each item in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height + 18, height: collectionView.frame.size.height)
    }
}

// MARK: - FontAdjustable

extension ProfileViewController: FontAdjustable {
    /// Adjusts font sizes of labels based on user settings.
    func adjustFontsSize() {
        progressTitleLabel.adjustFontSize(
            for: progressTitleLabel,
            minFontSize: Constants.progressTitleLabelMinFontSize,
            maxFontSize: Constants.progressTitleLabelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
        nationalityLabel.adjustFontSize(
            for: nationalityLabel,
            minFontSize: Constants.nationalityLabelMinFontSize,
            maxFontSize: Constants.nationalityLabelMaxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    /// Sets up an observer for font size adjustment notifications.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
