//
//  PlayerViewController2.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI
import UIKit

final class PlayerViewController2: CoreDataObservingViewController {
    
    // MARK: - Constants
    /// Constants used throughout the view controller for layout and default values.
    private enum Constants {
        static let profileHeight: CGFloat = 400
        static let octagonHeight: CGFloat = 500
        static let footballPitchHeight: CGFloat = 350
        static let statsHeight: CGFloat = 508
        static let statsSmallerHeight: CGFloat = 390
        static let pdfPadding: CGFloat = 8
        static let totalSubviews: Int = 4
        static let alternativeNames: String = "No name".localized
        static let scrollViewPadding: CGFloat = 0
    }
    
    // MARK: - ViewControllers
    
    /// Hosting controller for displaying the football pitch SwiftUI view.
    private let footballPitchHostingController = UIHostingController(
        rootView: FootballPitchView(
            positionInfo: [],
            height: Constants.footballPitchHeight
        )
    )
    
    /// Hosting controller for displaying the octagon SwiftUI view. It is lazily initialized.
    lazy var octagonHostingController = UIHostingController(
        rootView: OctagonView(
            height: Constants.octagonHeight,
            player1Data: nil,
            viewModel: OctagonViewModel()
        )
    )
    
    // MARK: - Coordinator
    
    /// The coordinator responsible for navigation and flow logic.
    private var coordinator: Coordinator?
    
    // MARK: - View Model
    
    private let viewModel: PlayerViewModel
    
    // MARK: - UserDefaultsManager
    
    /// Manager for user defaults, handling user preferences and settings.
    private var userDefaultsManager: UserDefaultsManaging
    
    // MARK: - UIView objects
    
    /// Scroll view for containing all the subviews.
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    /// Activity indicator to show loading state.
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    /// Images for the favorite star in empty state.
    private let starImageEmpty = UIImage(systemName: "star")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    
    /// Images for the favorite star in filled state.
    private let starImageFilled = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    
    /// Bar item for marking a player as favorite.
    lazy private var favouritePlayerItem = UIBarButtonItem(image: starImageEmpty, style: .done, target: self, action: #selector(favoritePlayer))
    
    // MARK: - Data
    /// Flag to check if the view is already loaded to prevent redundant setup.
    private var isAlreadyLoaded = false
    
    // MARK: - Initializers
    init(
        coordinator: Coordinator?,
        userDefaultsManager: UserDefaultsManaging,
        viewModel: PlayerViewModel
    ) {
        self.userDefaultsManager = userDefaultsManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if view is already loaded to prevent redundant setup
        guard !isAlreadyLoaded else {
            return
        }
        setupActivityIndicator()
        Task {
            DispatchQueue.main.async { [self] in
                makeUI()
                setupScrollView()
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                isAlreadyLoaded = true
                //checkFavorite()
                //saveInLastSavedList(playerInfo: viewModel.playerData)
            }
        }
    }
    
    /// Handles updates from Core Data.
    override func handleCoreDataUpdate(notification: Notification.Name) {
        super.handleCoreDataUpdate(notification: notification)
    }
    
    // MARK: - Private Methods
    
    /// Checks and updates the favorite status of the player.
    private func checkFavorite() {
        favouritePlayerItem.image = viewModel.loadPlayerInfo() != nil ? starImageFilled : starImageEmpty
    }
    
    /// Sets up the activity indicator in the center of the view.
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Accessibility Settings
        activityIndicator.isAccessibilityElement = true
        activityIndicator.accessibilityHint = "Indicates that player data is currently loading.".localized
    }
    
    /// Configures the scroll view and all of its views from all child view controllers.
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        // Set scroll view anchors
        scrollView.anchor(
            top: view.topAnchor,
            verticalTopSpace: Constants.scrollViewPadding,
            bottom: view.bottomAnchor,
            verticalBottomSpace: Constants.scrollViewPadding,
            left: view.leftAnchor,
            horizontalLeftSpace: Constants.scrollViewPadding,
            right: view.rightAnchor,
            horizontalRightSpace: Constants.scrollViewPadding,
            height: Constants.profileHeight +  Constants.octagonHeight + Constants.footballPitchHeight + Constants.statsHeight
        )
        
        // Content view within the scroll view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        // Set content view anchors
        contentView.anchor(
            top: scrollView.topAnchor,
            verticalTopSpace: Constants.scrollViewPadding,
            bottom: scrollView.bottomAnchor,
            verticalBottomSpace: Constants.scrollViewPadding,
            left: scrollView.leftAnchor,
            horizontalLeftSpace: Constants.scrollViewPadding,
            right: scrollView.rightAnchor,
            horizontalRightSpace: Constants.scrollViewPadding,
            width: UIScreen.main.bounds.width
        )
        
        // Guard to ensure player data is available
        guard let playerData = viewModel.playerData else {
            return
        }
        
        // Set position info if available
        if let positions = playerData.positions {
            footballPitchHostingController.rootView = FootballPitchView(
                positionInfo: positions,
                height: Constants.footballPitchHeight
            )
        }
        
        // Configure octagonHostingController's rootView
        octagonHostingController.rootView = OctagonView(
            height: Constants.octagonHeight,
            player1Data: playerData,
            viewModel: OctagonViewModel()
        )
        
        let statsViewController = StatsViewController(
            userDefaults: userDefaultsManager,
            selectedIndexSegment: 0,
            statsMode: .appMode,
            technicalViewModel: TechnicalViewModel(
                userDefaults: userDefaultsManager,
                player1: playerData
            ),
            mentalViewModel: MentalViewModel(
                userDefaults: userDefaultsManager,
                player1: playerData
            ),
            physicalViewModel: PhysicalViewModel(
                userDefaults: userDefaultsManager,
                player1: playerData
            ),
            goalKeeperViewModel: GoalKeeperViewModel(
                userDefaults: userDefaultsManager,
                player1: playerData
            ),
            hiddenViewModel: HiddenViewModel(
                userDefaults: userDefaultsManager,
                player1: playerData
            ),
            statsViewModel: StatsViewModel(
                playerData: playerData,
                appType: .appMode
            )
        )
        
        // Child view controllers to add
        let childViewControllers: [UIViewController] = [
            ProfileViewController(
                playerData: playerData,
                viewModel: ProfileViewModel()
            ),
            octagonHostingController,
            statsViewController,
            footballPitchHostingController
            // Add other view controllers here
        ]
        
        var lastView: UIView? = nil
        
        for (index, childVC) in childViewControllers.enumerated() {
            let height = getHeightForSubview(index: index)
            self.addChildViewController(childVC, to: contentView)
            configureChildView(childVC.view, height: height)
            NSLayoutConstraint.activate([
                childVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                childVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                childVC.view.heightAnchor.constraint(equalToConstant: height),
                lastView == nil ? childVC.view.topAnchor.constraint(equalTo: contentView.topAnchor) : childVC.view.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 8)
            ])
            lastView = childVC.view
        }
        
        if let lastView = lastView {
            NSLayoutConstraint.activate([
                lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
    
    // Returns the height for a subview based on its index.
    private func getHeightForSubview(index: Int) -> CGFloat {
        switch index {
        case 0: return Constants.profileHeight
        case 1: return Constants.octagonHeight
        case 2: return Constants.statsHeight
        case 3: return Constants.footballPitchHeight
        default: return 0
        }
    }
    
    /// Configures the appearance and layout of a child view controller's view.
    private func configureChildView(_ view: UIView, height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = height / 32
    }
    /// Sets up the navigation bar with `favouritePlayerItem` and `shareButton`
    private func setupNavBar() {
        self.title = viewModel.playerData?.name ?? Constants.alternativeNames
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissModal)
        )
        self.navigationItem.rightBarButtonItems = [
            favouritePlayerItem
        ]
        
        favouritePlayerItem.isAccessibilityElement = true
        favouritePlayerItem.accessibilityHint = "Taps to mark this player as your favorite.".localized
    }
    
    /// Dismisses the current modal view controller.
    ///
    /// This function is triggered when the user interacts with a "Done" button. It makes use of the `coordinator` object to handle the dismissal process. The `coordinator` is a part of a coordinator pattern implementation, which is used for navigation logic in the app. The dismissal is animated for a smooth transition.
    @objc private func dismissModal() {
        coordinator?.dismissModal(animated: true)
    }
    
    /// Configures the initial user interface of the view controller.
    ///
    /// This method sets the background color of the view and initializes the navigation bar by calling `setupNavBar`. It is typically called in the `viewDidLoad` method to ensure that the UI is set up as soon as the view loads.
    private func makeUI() {
        self.view.backgroundColor = .systemGray6
        setupNavBar()
    }
    
    /// Toggles the favorite status of the player.
    ///
    /// This method is triggered by tapping a favourite button. It checks the current favorite status of the player. If the player was not favorited, it marks the player as a favorite in the core data manager and updates the favorite player item's image to `starImageFilled`. If the player esd already favorited, it removes the player from favorites and updates the favorite player item's image to `starImageEmpty`.
    ///
    /// - Note: This method uses optional chaining and guard statements for error handling. It ensures that the player data is valid before attempting to change the favorite status.
    ///
    /// - Precondition:
    ///     - `playerData` must be non-nil and should contain a valid `playerId`.
    ///     - `coreDataManager` must be correctly configured for saving and deleting player information.
    @objc private func favoritePlayer() {
        guard let playerData = viewModel.playerData, !viewModel.isPlayerFavorited(playerId: playerData.playerId ?? "")
        else {
            favouritePlayerItem.image = starImageEmpty
            viewModel.deletePlayerInfo(playerId: viewModel.playerData?.playerId ?? "")
            return
        }
        
        let playerInfo = PlayerInfo(
            playerId: playerData.playerId ?? "",
            name: playerData.name ?? "",
            nationality: playerData.nationalities?[0] ?? "",
            club: playerData.club ?? ""
        )
        viewModel.savePlayerInfo(playerInfo)
        favouritePlayerItem.image = starImageFilled
    }

    private func saveInLastSavedList(playerInfo: PlayerData?) {
        let lastSavedPlayer = LastSearchedPlayerInfo(
            playerId: playerInfo?.playerId,
            name: playerInfo?.name,
            nationality: playerInfo?.nationalities?[0],
            club: playerInfo?.club,
            lastSearched: Date.now
        )
        viewModel.manageLastSearchedPlayersAndUpdate(newPlayerInfo: lastSavedPlayer, isPro: true)
    }
}
