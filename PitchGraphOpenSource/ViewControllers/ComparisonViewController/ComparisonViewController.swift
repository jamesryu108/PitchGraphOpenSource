//
//  ComparisonViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import SwiftUI
import UIKit

// MARK: - ComparisonViewController

/// `ComparisonViewController` is responsible for displaying a comparison view of two soccer players, including columns, octagon charts, and stats.
final class ComparisonViewController: UIViewController {
    
    // MARK: - Constants
    
    /// Constants defining UI layout configuration.
    private enum Constants {
        static let compareHeight: CGFloat = 660
        static let octagonHeight: CGFloat = 500
        static let statsHeight: CGFloat = 600
    }
    
    // MARK: - UI Components
    
    /// View controller for displaying comparison columns.
    private lazy var compareColumnViewController = CompareColumnViewController(
        player1: viewModel.player1,
        player2: viewModel.player2,
        height: Constants.compareHeight
    )
    
    /// Hosting controller for the octagon view. The rootView is written in SwiftUI.
    private lazy var doubleOctagonViewController = UIHostingController(
        rootView: OctagonView(
            height: Constants.octagonHeight,
            player1Data: viewModel.player1,
            player2Data: viewModel.player2,
            viewModel: OctagonViewModel()
        )
    )

    /// Stats view controller.
        private lazy var statsViewController = statsViewControllerMaker()
        
        /// Array of child view controllers to be added to the scroll view.
        private lazy var childVCs: [UIViewController] = [compareColumnViewController, doubleOctagonViewController, statsViewController]
        
        /// Activity indicator for loading state.
        private let activityIndicator = UIActivityIndicatorView(style: .large)
        
        /// Scroll view to contain the child view controllers.
        private var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
        
        /// Content view within the scroll view.
        private let contentView = UIView()
        
        /// ViewModel for handling comparison logic.
        private var viewModel: ComparisonViewModel
        
        /// Coordinator for navigation logic.
        private var coordinator: ComparisonCoordinator?
        
        /// Manager for user preferences and settings.
        private let userDefaults: UserDefaultsManaging
    
    // MARK: - Initializers
    
    init(
        coordinator: ComparisonCoordinator,
        userDefaults: UserDefaultsManaging,
        viewModel: ComparisonViewModel
    ) {
        self.userDefaults = userDefaults
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    deinit {
        removeChildViewControllers(childVCs)
    }
    
    // MARK: - UI Setup Methods
    
    /// Sets up the activity indicator.
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    /// Sets up the scroll view for the view controller.
    private func setupScrollView() {
        configureScrollView()
        setupContentView()
        addChildVCs(childVCs: childVCs)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(
            top: view.topAnchor,
            verticalTopSpace: 0,
            bottom: view.bottomAnchor,
            verticalBottomSpace: 0,
            left: view.leftAnchor,
            horizontalLeftSpace: 0,
            right: view.rightAnchor,
            horizontalRightSpace: 0,
            height: Constants.compareHeight
        )
    }
    
    /// Sets up the content view within the scroll view.
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    /// Adds and configures child view controllers to the scroll view.
    private func addChildVCs(childVCs: [UIViewController]) {
        var lastView: UIView? = nil

            // Iterate through each child view controller, add it to the contentView, and configure its view.
            for (index, childVC) in childVCs.enumerated() {
                let height: CGFloat
                switch index {
                case 0: height = Constants.compareHeight
                case 1: height = Constants.octagonHeight
                case 2: height = Constants.statsHeight
                default: continue
                }

                // Use the extension method to add the child view controller.
                self.addChildViewController(childVC, to: contentView)
                
                // Configure the view of the child view controller.
                guard let subview = childVC.view else {
                    return
                }
                
                subview.layer.borderColor = UIColor.systemGray5.cgColor
                subview.layer.borderWidth = 0.5
                subview.layer.cornerRadius = height / 32
                subview.translatesAutoresizingMaskIntoConstraints = false

                // Apply constraints to the subview.
                NSLayoutConstraint.activate([
                    subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                    subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                    subview.heightAnchor.constraint(equalToConstant: height),
                    lastView == nil ? subview.topAnchor.constraint(equalTo: contentView.topAnchor) : subview.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 8)
                ])
                lastView = subview
            }

            // Ensure the last subview is constrained to the bottom of the contentView.
            if let lastView = lastView {
                NSLayoutConstraint.activate([
                    lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            }
    }
    
    /// Sets up the navigation bar.
    private func setupNavBar() {
        self.title = "Compare".localized
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    }
    
    /// Dismisses the modal view.
    @objc private func dismissModal() {
        coordinator?.dismissModal(animated: true)
    }
    
    /// Sets up the entire user interface.
    private func setupUI() {
        self.view.backgroundColor = .systemGray6
        setupNavBar()
        setupScrollView()
    }
    
    /// Creates and returns an instance of `StatsViewController` with all necessary dependencies.
    ///
    /// This function encapsulates the creation and configuration of `StatsViewController` along with its required ViewModels.
    /// It creates instances of `TechnicalViewModel`, `MentalViewModel`, `PhysicalViewModel`, and `GoalKeeperViewModel`
    /// using the shared `userDefaults`, `player1`, and `player2` properties. These ViewModels are then passed
    /// to the `StatsViewController` initializer along with other required parameters.
    /// The function ensures that `StatsViewController` is fully configured with all the necessary data
    /// and dependencies before being returned for use.
    ///
    /// - Returns: A fully configured instance of `StatsViewController`.
    private func statsViewControllerMaker() -> StatsViewController {

        // Instantiate the ViewModel for technical stats with necessary dependencies
        lazy var technicalViewModel = TechnicalViewModel(
            userDefaults: userDefaults,
            player1: viewModel.player1 ?? PlayerData.messiPlayerData,
            player2: viewModel.player2
        )
        
        // Instantiate the ViewModel for mental stats with necessary dependencies
        lazy var mentalViewModel = MentalViewModel(
            userDefaults: userDefaults,
            player1: viewModel.player1 ?? PlayerData.messiPlayerData,
            player2: viewModel.player2
        )
        
        // Instantiate the ViewModel for physical stats with necessary dependencies
        lazy var  physicalViewModel = PhysicalViewModel(
            userDefaults: userDefaults,
            player1: viewModel.player1 ?? PlayerData.messiPlayerData,
            player2: viewModel.player2
        )
        
        // Instantiate the ViewModel for goalkeeping stats with necessary dependencies
        lazy var  goalKeeperViewModel = GoalKeeperViewModel(
            userDefaults: userDefaults,
            player1: viewModel.player1 ?? PlayerData.messiPlayerData,
            player2: viewModel.player2
        )
        
        // Instantiate the ViewModel for hidden stats with necessary dependencies
        lazy var hiddenViewModel = HiddenViewModel(
            userDefaults: userDefaults,
            player1: viewModel.player1 ?? PlayerData.messiPlayerData,
            player2: viewModel.player2
        )
        
        lazy var statsViewModel = StatsViewModel(playerData: viewModel.player1 ?? PlayerData.messiPlayerData, playerData2: viewModel.player2, appType: .compareMode)
        
        // Instantiate and return StatsViewController with all necessary ViewModels and other dependencies
        return StatsViewController(
            userDefaults: userDefaults,
            selectedIndexSegment: 0,
            statsMode: .compareMode,
            technicalViewModel: technicalViewModel,
            mentalViewModel: mentalViewModel,
            physicalViewModel: physicalViewModel,
            goalKeeperViewModel: goalKeeperViewModel, hiddenViewModel: hiddenViewModel,
            statsViewModel: statsViewModel
        )
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}
