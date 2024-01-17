//
//  SearchTwoPlayersViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// A view controller for searching and comparing two players.
final class SearchTwoPlayersViewController: UIViewController {
    
    // MARK: - Constants
    /// Struct to hold all the constants used in the view controller.
    enum Constants {
        static let minimumPlayerViewHeight: CGFloat = 50
        static let maximumPlayerViewHeight: CGFloat = 110
        static let textFieldSpacing: CGFloat = 10
        static let textFieldPadding: CGFloat = 20
        static let proceedButtonCornerRadius: CGFloat = 50 / 8
        static let proceedButtonHeight: CGFloat = 50
        static let proceedButtonWidth: CGFloat = 100
        static let proceedButtonTopSpace: CGFloat = 20
        static let playerViewDiameter: CGFloat = 80
        static let proceedButtonAlphaSelected: CGFloat = 1.0
        static let proceedButtonAlphaUnselected: CGFloat = 0.2
        static let debounceTime: CGFloat = 0.5
        static let minFontSize: CGFloat = 12
        static let maxFontSize: CGFloat = 18
    }
    
    // MARK: - UI Components
    /// Stack view to arrange text fields vertically.
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = Constants.textFieldSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// Button to proceed with the comparison of players.
    private let proceedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Proceed".localized, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.proceedButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityHint = "Proceeds to compare the selected players. If the button looks faded, make sure two players are selected".localized
        return button
    }()
    
    /// Custom view for displaying the first player's information.
    private let firstPlayerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        view.accessibilityHint = "Displays information for the first player".localized
        return view
    }()
    
    /// Custom view for displaying the second player's information.
    private let secondPlayerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        view.accessibilityHint = "Displays information for the second player".localized
        return view
    }()
    
    // MARK: - Coordinator
    /// Coordinator for managing navigation and flow.
    private weak var coordinator: SearchTwoCoordinator?
    
    /// Search controller to manage player search.
    lazy var searchController = UISearchController(searchResultsController: ResultsViewController(userDefaultManager: userDefaultsManager))
    
    // MARK: - Data
    /// Temporary storage for search results.
    private var results: SimilarPlayers?
    
    /// Timer to handle search debouncing.
    private var searchTimer: Timer?
    
    /// Data for the first player.
    private var player1: PlayerData?
    
    /// Data for the second player.
    private var player2: PlayerData?

    // MARK: - Constraints
    /// Height constraint for the first player view.
    private var player1HeightAnchor: NSLayoutConstraint?
    
    /// Height constraint for the second player view.
    private var player2HeightAnchor: NSLayoutConstraint?
    
    /// Manager to handle user defaults.
    private let userDefaultsManager: UserDefaultsManaging
    
    // MARK: - ViewModel
    
    /// ViewModel to handle the business logic.
    private let viewModel: ComparisonViewModel
                                                   
    // MARK: - Initialization
    /// Initializes a new instance of the view controller.
    init(coordinator: SearchTwoCoordinator? = nil, userDefaultsManager: UserDefaultsManaging, viewModel: ComparisonViewModel) {
        self.userDefaultsManager = userDefaultsManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    /// Called after the view controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cellWasSelected()
        changeProceedButton()
        setupHandler()
        setupFontSizeAdjustmentObserver()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    // MARK: - Setup Methods
    /// Sets up handlers for player views.
    private func setupHandler() {
        firstPlayerView.onClose = { [weak self] in
            self?.player1 = nil
            self?.firstPlayerView.configureWith(player: nil)
            self?.userDefaultsManager.delete(key: UserDefaultsKey.playerData1)
            self?.changeProceedButton()
        }
        
        secondPlayerView.onClose = { [weak self] in
            self?.player2 = nil
            self?.secondPlayerView.configureWith(player: nil)
            UserDefaultsManager.shared.delete(key: UserDefaultsKey.playerData2)
            self?.changeProceedButton()
        }
    }
    
    /// Sets up the search controller.
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Items".localized
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Sets up the navigation bar.
    private func setupNavBar() {
        self.title = "Compare".localized
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Sets up the proceed button.
    private func setupButton() {
        self.view.addSubview(proceedButton)
        
        proceedButton.anchor(
            top: textFieldStackView.bottomAnchor,
            verticalTopSpace: Constants.proceedButtonTopSpace,
            width: Constants.proceedButtonWidth,
            height: Constants.proceedButtonHeight,
            centerX: view.centerXAnchor
        )
        
        cellWasSelected()
        
        let firstGesture = UITapGestureRecognizer(target: self, action: #selector(firstButtonAction))
        let secondGesture = UITapGestureRecognizer(target: self, action: #selector(secondButtonAction))
        
        firstPlayerView.addGestureRecognizer(firstGesture)
        secondPlayerView.addGestureRecognizer(secondGesture)
        
        proceedButton.addTarget(self, action: #selector(goToModal), for: .touchUpInside)
    }
    
    /// Action to go to the modal view.
    @objc func goToModal() {
        coordinator?.openCompareVC()
    }
    
    /// Sets up the stack view.
    private func setupStack() {
        self.view.addSubview(textFieldStackView)
        
        textFieldStackView.addArrangedSubview(firstPlayerView)
        textFieldStackView.addArrangedSubview(secondPlayerView)
        
        NSLayoutConstraint.activate([
            firstPlayerView.heightAnchor.constraint(equalToConstant: Constants.playerViewDiameter),
            secondPlayerView.heightAnchor.constraint(equalToConstant: Constants.playerViewDiameter)
        ])
        
        textFieldStackView.anchor(
            left: view.leftAnchor,
            horizontalLeftSpace: Constants.textFieldPadding,
            right: view.rightAnchor,
            horizontalRightSpace: Constants.textFieldPadding,
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
    }
    
    /// Action for the first button.
    @objc private func firstButtonAction() {
        (searchController.searchResultsController as? ResultsViewController)?.buttonID = 0
        searchController.searchBar.isHidden = false
        searchController.searchBar.becomeFirstResponder()
    }
    
    /// Action for the second button.
    @objc private func secondButtonAction() {
        (searchController.searchResultsController as? ResultsViewController)?.buttonID = 1
        searchController.searchBar.isHidden = false
        searchController.searchBar.becomeFirstResponder()
    }
    
    /// Sets up the UI.
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        setupNavBar()
        setupStack()
        setupButton()
        setupSearchController()
        adjustFontsSize()
    }
}

// MARK: - UISearchResultsUpdating
extension SearchTwoPlayersViewController: UISearchResultsUpdating {
    
    /// Called when the search results need to be updated, for instance, when the user types in the search bar.
    func updateSearchResults(for searchController: UISearchController) {
        // Invalidate and reset the existing timer.
        searchTimer?.invalidate()
        searchTimer = nil
        // Set up a new timer with a delay for debounce functionality.
        // This prevents the app from making a network request for each letter the user types.
        searchTimer = Timer.scheduledTimer(
            timeInterval: Constants.debounceTime,
            target: self,
            selector: #selector(self.searchTextChanged(_:)),
            userInfo: searchController.searchBar.text,
            repeats: false
        )
    }
    
    /// Called when the search text changes and the debounce timer fires.
    @objc func searchTextChanged(_ timer: Timer) {
        guard let searchText = timer.userInfo as? String else {
            return
        }
        
        // Do not perform a search if the search text is empty.
        guard !searchText.isEmpty else {
            results = nil
            return
        }
        
        // Fetch results based on the current search text.
        fetchSearchResults(for: searchText)
    }
    
    /// Handles the logic for when a cell in the results is selected.
    private func cellWasSelected() {
        // Load player 1 data from UserDefaults and configure the first player view.
        Task.init {
            do {
                let player1Data = try await UserDefaultsManager.shared.load(for: UserDefaultsKey.playerData1, as: PlayerData.self)
                player1 = player1Data
                viewModel.player1 = player1Data
                firstPlayerView.configureWith(player: player1)
                
            } catch {
                // Show an error only if player 2 is not selected.
                guard self.player2 != nil else {
                    return
                }
                
                showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
            }
        }
        
        // Load player 2 data from UserDefaults and configure the second player view.
        Task.init {
            do {
                let player2Data = try await UserDefaultsManager.shared.load(for: UserDefaultsKey.playerData2, as: PlayerData.self)
                player2 = player2Data
                viewModel.player2 = player2Data
                secondPlayerView.configureWith(player: player2)
                changeProceedButton()
            } catch {
                // Show an error only if player 1 is not selected.
                guard self.player1 != nil else {
                    return
                }
                showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
            }
        }
    }
    
    /// Updates the proceed button's enabled state and appearance based on whether both players are selected.
    private func changeProceedButton() {
        let playersSelected = player1 != nil && player2 != nil
        proceedButton.isEnabled = playersSelected
        proceedButton.alpha = playersSelected ? Constants.proceedButtonAlphaSelected : Constants.proceedButtonAlphaUnselected
    }
    
    /// Fetches search results based on the given query.
    private func fetchSearchResults(for query: String) {
        // Networking code to fetch results based on the query.
        // Update the `results` property with the fetched data.
        Task {
            
            await viewModel.callForPlayer(name: query, isDebug: false)
            if let searchResults = viewModel.playerData {
                (searchController.searchResultsController as? ResultsViewController)?.results = searchResults
                (searchController.searchResultsController as? ResultsViewController)?.cellSelectionHandler = { [weak self] in
                    Task { @MainActor in
                        self?.cellWasSelected()
                    }
                }
            }
        }
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

// MARK: - UISearchBarDelegate
extension SearchTwoPlayersViewController: UISearchBarDelegate {
    
    /// Called when the cancel button on the search bar is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.isHidden = true
    }
}

// MARK: - FontAdjustable
extension SearchTwoPlayersViewController: FontAdjustable {
    
    /// Adjusts the font size of the proceed button's text based on the user's preferred content size category.
    @objc func adjustFontsSize() {
        proceedButton.adjustFontSizeButtonText(
            for: proceedButton,
            minFontSize: Constants.minFontSize,
            maxFontSize: Constants.maxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    /// Sets up an observer to listen for changes in the user's preferred content size category.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
