//
//  PlayerSearchViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import Combine
import SwiftUI
import UIKit

/// `PlayerSearchViewController` manages the UI and logic for player search functionality.
final class PlayerSearchViewController: UIViewController {
    
    // MARK: - Constants
    /// Constants used for configuring UI elements in the view controller.
    private enum Constants {
        static let padding: CGFloat = 8
        static let minimumItemSpacing: CGFloat = 10
        static let columns: Int = 1
        static let height: CGFloat = 90
        static let collectionViewPadding: CGFloat = 0
        static let debounceTime: TimeInterval = 1.0
        static let debounceTimeForAccessibility: TimeInterval = 5.0
    }
    
    // MARK: - Section Enum
    /// Defines sections in the collection view.
    private enum Section {
        case main
    }
    
    // MARK: - UI Components
    /// Lazily initialized collection view for displaying player search results.
    lazy private var collectionView: UICollectionView = configureCollectionView()
    
    /// Activity indicator to signify loading states.
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    // MARK: - Properties
    var coordinator: PlayerSearchCoordinator?
    
    /// Diffable data source for managing collection view data.
    private var dataSource: UICollectionViewDiffableDataSource<Section, PlayerData>!
    
    /// ViewModel handling the business logic for player search.
    private let viewModel: PlayerSearchViewModel
    
    /// Set of Combine cancellables for managing subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// Search controller for implementing search functionality.
    lazy private var searchController = UISearchController(searchResultsController: nil)
    
    /// Current search parameters.
    private var searchParameter: SearchParameter?
    
    private var currentDebounceTime: TimeInterval {
        return UIAccessibility.isVoiceOverRunning ? Constants.debounceTimeForAccessibility : Constants.debounceTime
    }
    
    // MARK: - UserDefaultsManager
    /// Manager for handling user defaults.
    private let userDefaultsManager: UserDefaultsManaging
    
    // MARK: - Initializers
    /// Initializes the view controller with necessary dependencies.
    init(
        coordinator: PlayerSearchCoordinator,
        viewModel: PlayerSearchViewModel,
        userDefaultsManager: UserDefaultsManaging
    ) {
        self.userDefaultsManager = userDefaultsManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupBindings()
        loadSearchQuery()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    private func loadSearchQuery() {
        searchParameter = userDefaultsManager.loadSearchParameters()
    }
    
    // MARK: - Setup Binding
    /// Sets up bindings with the ViewModel using Combine.
    private func setupBindings() {
        viewModel.$state
            .sink { [weak self] state in
                DispatchQueue.main.async {
                    switch state {
                    case .loading:
                        self?.activityIndicator.startAnimating()
                    case .success(let players):
                        self?.updateData(players: players)
                        self?.activityIndicator.stopAnimating()
                    case .failed(let error):
                        self?.activityIndicator.stopAnimating()
                        self?.showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
                    case .idle:
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func showSettings() {
        coordinator?.navigateToSettings()
    }
    
    /// Configures the navigation bar of the view controller.
    private func setupNavBar() {
        self.title = "Player Search".localized
        
        // Setup the right navigation bar button
        let filterButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(showParameterVC)
        )
        filterButton.isAccessibilityElement = true
        filterButton.accessibilityHint = "Click on here to filter your search based on parameters such as age, current ability, potential ability.".localized
         
        // Setup the right navigation bar button
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        settingsButton.isAccessibilityElement = true
        settingsButton.accessibilityHint = "Click here to change system settings.".localized
        
        self.navigationItem.leftBarButtonItem = settingsButton
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    /// Configures the search controller for the view controller.
    private func setupSearchController() {

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Items".localized
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map {
                ($0.object as? UISearchTextField)?.text ?? ""
            }
            .debounce(for: .seconds(currentDebounceTime), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                guard let self else {
                    return
                }
                getPlayers(
                    name: searchText,
                    searchParameters: searchParameter
                )
                viewModel.name = searchText
            }
            .store(in: &cancellables)
    }
    
    /// Retrieves player data based on the given name and optional search parameters.
    ///
    /// This function initiates an asynchronous task to fetch players from the `viewModel`. It supports a debug mode for additional logging and debugging during development. In case of any errors during the fetch process, it presents an alert with the error message.
    ///
    /// The function utilizes conditional compilation directives (`#if DEBUG`) to toggle the debug mode based on the build configuration. This approach ensures that additional debugging information is available during development but is excluded from production builds.
    ///
    /// - Parameters:
    ///   - name: The name of the player to search for. It's a required parameter to initiate the search.
    ///   - searchParameters: Optional search parameters to refine the search. It includes criteria like age range, ability range, etc. Defaults to `nil` if no specific parameters are provided.
    ///
    /// The function uses the `Task` API for asynchronous execution. This ensures that the UI remains responsive while the network request is being processed.
    private func getPlayers(
        name: String,
        searchParameters: SearchParameter? = nil
    ) {
        Task {
            do {
                try await viewModel.getPlayers(
                    name: name,
                    searchParameters: searchParameters,
                    isDebug: false
                )
            } catch {
                showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
            }
        }
    }
    
    /// Sets up and configures the activity indicator.
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// Comprehensive method to set up the user interface.
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        updateData(players: [])
        setupNavBar()
        setupSearchController()
        setupActivityIndicator()
    }
    
    /// Configures the collection view for displaying search results.
    private func configureCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createColumnFlowLayout(
            in: self.view,
            padding: Constants.padding,
            height: Constants.height,
            minimumItemSpacing: Constants.minimumItemSpacing,
            totalItems: Constants.columns
        ))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PlayerSearchCollectionViewCell.self, forCellWithReuseIdentifier: PlayerSearchCollectionViewCell.reuseIdentifier)
        collectionView.register(EmptyStateCollectionViewCell.self, forCellWithReuseIdentifier: EmptyStateCollectionViewCell.reuseIdentifier)
        collectionView.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: Constants.collectionViewPadding,
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
            verticalBottomSpace: Constants.collectionViewPadding,
            left: self.view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: Constants.collectionViewPadding,
            right: self.view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: Constants.collectionViewPadding
        )
        
        return collectionView
    }
    
    /// Presents the parameter view controller for setting search filters.
    @objc func showParameterVC() {
        let parameterVC = ParameterViewController(coordinator: coordinator, userDefaultsManager: userDefaultsManager)
        parameterVC.delegate = self  // Set PlayerSearchViewController as the delegate
        parameterVC.modalPresentationStyle = .pageSheet
        parameterVC.isModalInPresentation = true
        
        coordinator?.presentModal(UINavigationController(rootViewController: parameterVC), animated: true)
    }
    
    /// Presents a modal view controller for the selected player.
    @objc func showModalView(index: Int) {
        let userDefaultsManager = UserDefaultsManager.shared
        let coreDataManager = CoreDataManager.shared
        let viewModel = PlayerViewModel(coreDataManager: coreDataManager)
        viewModel.givePlayerData(playerData: self.viewModel.playerData[index])
        let playerView = PlayerViewController2(
            coordinator: coordinator,
            userDefaultsManager: userDefaultsManager,
            viewModel: viewModel
        )
        playerView.modalPresentationStyle = .pageSheet
        playerView.isModalInPresentation = true
        coordinator?.presentModal(UINavigationController(rootViewController: playerView), animated: true)
    }
    
    /// Configures the data source for the collection view.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PlayerData>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, player) -> UICollectionViewCell? in
            if player.playerId == nil {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCollectionViewCell.reuseIdentifier, for: indexPath) as? EmptyStateCollectionViewCell else {
                    fatalError("EmptyStateCollectionViewCell does not exist")
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? PlayerSearchCollectionViewCell else {
                    fatalError("PlayerSearchCollectionViewCell does not exist")
                }
                cell.setupUI(playerData: player, height: Constants.height)
                return cell
            }
        })
    }
    
    /// Updates the data in the collection view with new players or clears it.
    private func updateData(players: [PlayerData], clear: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlayerData>()
        snapshot.appendSections([.main])
        if clear || players.isEmpty {
            let emptyPlayer = PlayerData()
            snapshot.appendItems([emptyPlayer])
        } else {
            snapshot.appendItems(players)
        }
        collectionView.isScrollEnabled = players.isEmpty ? false : true
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        viewModel.playerData = players
    }
    
    /// Clears the current search results and resets the ViewModel.
    @objc private func clearItems() {
        updateData(players: [], clear: true)
        viewModel.clearPlayers()
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

// MARK: - UITextFieldDelegate
extension PlayerSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension PlayerSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !viewModel.playerData.isEmpty else {
            return
        }
        showModalView(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlayerSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let player = dataSource.itemIdentifier(for: indexPath)
        if player?.playerId == nil {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            }
            return flowLayout.itemSize
        }
    }
}

// MARK: - UISearchResultsUpdating
extension PlayerSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
    }
    
    /// Fetches search results from the ViewModel based on the query and optional search parameters.
    private func fetchSearchResults(for query: String, searchParameter: SearchParameter? = nil) {
        getPlayers(name: query, searchParameters: searchParameter)
    }
}

// MARK: - UISearchBarDelegate
extension PlayerSearchViewController: UISearchBarDelegate {
    
    /// Handles the action when the cancel button in the search bar is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearItems()
    }
    
    /// Clears the current search results when the search bar starts editing.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        clearItems()
    }
}

// MARK: - ParameterViewControllerDelegate
extension PlayerSearchViewController: ParameterViewControllerDelegate {
    
    /// Updates search parameters based on user selections in the parameter view controller.
    func didUpdateParameters(ageRange: ClosedRange<Int>, abilityRange: ClosedRange<Int>, potentialRange: ClosedRange<Int>, sortOption: SortOption) {
        // Create a new SearchParameter instance with the updated values.
        let searchParameter = SearchParameter(ageRange: ageRange,
                                              abilityRange: abilityRange,
                                              potentialRange: potentialRange,
                                              sortOption: sortOption)
        
        // Persist the updated search parameters using UserDefaultsManager.
        userDefaultsManager.saveSearchParameters(searchParameter)
        // Update the local search parameters for subsequent searches.
        self.searchParameter = searchParameter
        
        guard viewModel.name != nil else {
            return
        }
        // Trigger a new search with the updated parameters.
        fetchSearchResults(for: viewModel.name ?? "", searchParameter: searchParameter)
    }
}

//final class PlayerSearchViewController: UIViewController {
//    
//    weak var coordinator: PlayerCoordinator?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Create a new button
//        let button = UIButton(type: .system) // .system gives you a basic button
//        button.setTitle("Search", for: .normal) // Set the button title
//
//        // Style the button (optional)
//        button.backgroundColor = .blue
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 10
//        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//
//        // Add the button to the view
//        view.addSubview(button)
//
//        // Disable autoresizing masks and set up constraints
//        button.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            button.widthAnchor.constraint(equalToConstant: 100), // Set the width of the button
//            button.heightAnchor.constraint(equalToConstant: 40) // Set the height of the button
//        ])
//
//        // Optional: Add an action to the button
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//    }
//
//    @objc func buttonTapped() {
//        coordinator?.navigateToSettings()
//    }
//}
