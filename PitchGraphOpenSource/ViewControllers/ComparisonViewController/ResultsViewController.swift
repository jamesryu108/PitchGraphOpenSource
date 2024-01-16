//
//  ResultsViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `ResultsViewController` is a subclass of `UICollectionViewController` designed to display a list of player data.
final class ResultsViewController: UICollectionViewController {
    
    // MARK: - Section Enum
    /// Defines sections in the collection view.
    enum Section {
        case main
    }
    
    // MARK: - Typealiases
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PlayerData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PlayerData>
    
    // MARK: - Properties
    /// The array of `PlayerData` to display.
    var results: [PlayerData] = [] {
        didSet {
            applySnapshot()
        }
    }

    /// The diffable data source for the collection view.
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseIdentifier, for: indexPath) as? ResultCell else {
                fatalError("Cannot create ResultCell")
            }
            cell.configure(with: item)
            return cell
        }
        return dataSource
    }()
    
    /// Instance of `UserDefaultsManager` for managing user defaults.
    let userDefaultsManger: UserDefaultsManaging

    /// Identifier for the selected button.
    var buttonID: Int?
    
    /// Array to keep track of selected items.
    var selectedItems: [Int] = []
    
    /// Handler for cell selection.
    var cellSelectionHandler: (() -> ())?

    // MARK: - Constants
    /// Struct for defining UI constants.
    enum Constants {
        static let itemWidth: CGFloat = UIScreen.main.bounds.width - 16
        static let itemHeight: CGFloat = 50
        static let collectionInsetValue: CGFloat = 10
        static let collectionMinimumLineSpacing: CGFloat = 10
    }
    
    // MARK: - Initialization
    /// Initializes the view controller with a custom collection view layout.
    init(userDefaultManager: UserDefaultsManaging) {
                
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.collectionInsetValue, left: Constants.collectionInsetValue, bottom: Constants.collectionInsetValue, right: Constants.collectionInsetValue)
        self.userDefaultsManger = userDefaultManager

        super.init(collectionViewLayout: layout)
    }
    
    /// Required initializer that throws a fatal error if used.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    /// Sets up the collection view when the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        applySnapshot()
    }
    
    // MARK: - Setup Methods
    /// Configures the collection view properties and registers the cell type.
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
        collectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseIdentifier)
        collectionView.dataSource = dataSource
    }
    
    /// Updates the results array and applies the snapshot to refresh the data.
    private func updateResults(newResults: [PlayerData]) {
        self.results = newResults
        applySnapshot()
    }
    
    /// Applies a snapshot to the collection view to update its data.
    private func applySnapshot(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(results)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate
extension ResultsViewController {
    /// Handles the selection of an item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let buttonID else {
            return
        }

        // Copy the relevant data to a local constant
        let selectedPlayerData = results[indexPath.row]
        let key = buttonID == 0 ? UserDefaultsKey.playerData1 : UserDefaultsKey.playerData2

        Task.init {
            do {
                try await UserDefaultsManager.shared.savePlayerData(data: selectedPlayerData, key: key)
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
                }
            }
        }

        self.dismiss(animated: true) {
            self.cellSelectionHandler?()
        }
    }
}
