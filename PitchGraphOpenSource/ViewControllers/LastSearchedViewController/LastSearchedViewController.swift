//
//  LastSearchedViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import Combine
import UIKit

/// `LastSearchedViewController` is responsible for displaying and managing a list of players that were searched.
/// It uses a `UICollectionView` to present the data and handles various user interactions.
final class LastSearchedViewController: UIViewController {
    
    // MARK: - Constants
    // Constants used for layout configuration of the collection view.
    private enum Constants {
        static let padding: CGFloat = 8
        static let minimumItemSpacing: CGFloat = 10
        static let columns: Int = 1
        static let height: CGFloat = 90
        static let collectionViewPadding: CGFloat = 0
        static let debounceTimer: CGFloat = 0.5
    }
    
    // Enumeration representing the sections of the collection view.
    private enum Section {
        case main
    }
    
    // MARK: - CollectionView
    /// Lazy-initialized collection view with custom layout.
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createColumnFlowLayout(
            in: self.view,
            padding: Constants.padding,
            height: Constants.height,
            minimumItemSpacing: Constants.minimumItemSpacing,
            totalItems: Constants.columns
        ))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Properties
    /// Diffable data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<Section, LastSearchedPlayerInfo>!

    /// ViewModel that handles business logic.
    private let viewModel: LastSearchViewModel
        
    /// Coordinator for managing navigation flow.
    private var coordinator: LastSearchedCoordinator?
                
    /// Set of cancellable objects for managing memory in Combine.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    /// Custom initializer accepting an optional coordinator.
    init(
        coordinator: LastSearchedCoordinator? = nil,
        viewModel: LastSearchViewModel
    ) {
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
        setupNSPersistentRemoteChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllPlayers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    // MARK: - Private functions
    /// Sets up observation for CoreData remote changes.
    private func setupNSPersistentRemoteChange() {
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange, object: nil)
            .debounce(for: .seconds(Constants.debounceTimer), scheduler: RunLoop.main)
            .sink { [weak self] notification in
                guard let self else {
                    return
                }
                self.handleDebouncedCoreDataUpdate(notification)
            }
            .store(in: &cancellables)
    }
    
    /// Handles updates from CoreData after a debounce period.
    @objc private func handleDebouncedCoreDataUpdate(_ notification: Notification) {
        loadAllPlayers()
    }

    /// Clears the items displayed in the collection view.
    @objc private func clearItems() {
        updateData(with: [], clear: true)
        viewModel.players = []
    }
    
    /// Updates the collection view's data source with new data.
    private func updateData(with players: [LastSearchedPlayerInfo], clear: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LastSearchedPlayerInfo>()
        snapshot.appendSections([.main])

        if players.isEmpty && clear {
            // When there are no players and clear is true, add a placeholder
            let placeholder = LastSearchedPlayerInfo() // Create a placeholder with nil values
            snapshot.appendItems([placeholder])
        } else {
            snapshot.appendItems(players)
        }

        collectionView.isScrollEnabled = !players.isEmpty
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    /// Configures the collection view layout and registers cell types.
    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(EmptyLastSearchedCollectionViewCell.self, forCellWithReuseIdentifier: EmptyLastSearchedCollectionViewCell.reuseIdentifier)
        collectionView.register(LastSearchCollectionViewCell.self, forCellWithReuseIdentifier: LastSearchCollectionViewCell.reuseIdentifier)
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
    }
    
    /// Configures the data source for the collection view.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, LastSearchedPlayerInfo>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, player) -> UICollectionViewCell? in
            if player.playerId == nil {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyLastSearchedCollectionViewCell.reuseIdentifier, for: indexPath) as? EmptyLastSearchedCollectionViewCell else {
                    fatalError("EmptyLastSearchedCollectionViewCell does not exist")
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? LastSearchCollectionViewCell else {
                    fatalError("LastSearchCollectionViewCell does not exist")
                }
                cell.configure(playerData: player, height: Constants.height)
                return cell
            }
        })
    }
    
    /// Sets up the navigation bar appearance and functionality.
    private func setupNavBar() {
        self.title = "Last Searched".localized
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let clearButton = UIBarButtonItem(title: "Clear".localized, style: .plain, target: self, action: #selector(clearButtonTapped))
        self.navigationItem.rightBarButtonItem = clearButton
    }
    
    /// Sets up the overall user interface.
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        setupNavBar()
        configureCollectionView()
    }
    
    /// Loads all players from CoreData and updates the collection view.
    private func loadAllPlayers() {
        viewModel.players = viewModel.fetchAllPlayers()
        updateData(with: viewModel.players)
    }
    
    /// Handles the 'Clear' button tap action.
    @objc private func clearButtonTapped() {
        viewModel.players = [] // Clear the players in the ViewModel
        updateData(with: viewModel.players, clear: true)
        viewModel.deleteAllPlayerInfo()
    }
    
    /// Presents a modal view for a specific player.
    @objc func showModalView(index: Int) {
        Task {
            await viewModel.callForPlayer(id: viewModel.players[index].playerId ?? "")
            let coreDataManager = CoreDataManager.shared
            let playerViewModel = PlayerViewModel(coreDataManager: coreDataManager)
            
            playerViewModel.givePlayerData(playerData: viewModel.playerData)
                        
            let userDefaultManager = UserDefaultsManager.shared
            let playerView = PlayerViewController2(
                coordinator: coordinator,
                userDefaultsManager: userDefaultManager,
                viewModel: playerViewModel
            )
            playerView.isModalInPresentation = true
            playerView.modalPresentationStyle = .pageSheet
            
            coordinator?.presentModal(UINavigationController(rootViewController: playerView), animated: true)
        }
    }
    
    private func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

// MARK: - UICollectionViewDelegate
extension LastSearchedViewController: UICollectionViewDelegate {
    // Handles selection of an item in the collection view.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.players.isEmpty else {
            return
        }
        showModalView(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LastSearchedViewController: UICollectionViewDelegateFlowLayout {
    // Determines the size for each item in the collection view.
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

// MARK: - UISearchBarDelegate
extension LastSearchedViewController: UISearchBarDelegate {
    // Handles the cancellation of a search.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearItems()
    }
    
    // Clears items when search begins.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        clearItems()
    }
}
