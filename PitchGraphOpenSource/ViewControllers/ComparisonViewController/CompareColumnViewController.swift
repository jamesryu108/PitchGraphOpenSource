//
//  CompareColumnViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `CompareColumnViewController` is responsible for displaying a collection view that compares two soccer players' data.
final class CompareColumnViewController: UIViewController {
    
    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PlayerComparison>!
    private let viewModel = CompareComparisonViewModel()
    private var player1: PlayerData?
    private var player2: PlayerData?
    
    enum Section {
        case main
    }
    
    // MARK: - Values
    
    let height: CGFloat
    
    // MARK: - Initialization

    /// Initializes `CompareColumnViewController` with two players' data.
    init(player1: PlayerData?, player2: PlayerData?, height: CGFloat) {
        self.player1 = player1
        self.player2 = player2
        self.height = height
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    /// Called after the view controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        applyInitialSnapshots()
    }
    
    // MARK: - UI Setup Methods

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    /// Sets up the collection view for the view controller.
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(ComparisonCell.self, forCellWithReuseIdentifier: ComparisonCell.reuseIdentifier)
        collectionView.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: 0,
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
            verticalBottomSpace: 0,
            left: self.view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: 0,
            right: self.view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: 0
        )
        collectionView.layer.cornerRadius = height / 32
    }
    
    // MARK: - DataSource Configuration

    /// Configures the data source for the collection view.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PlayerComparison>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, comparison: PlayerComparison) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ComparisonCell.reuseIdentifier,
                for: indexPath) as? ComparisonCell else { fatalError("ComparisonCell does not exist") }
            cell.setupCell(with: comparison, indexPath: indexPath.row)
            return cell
        }
    }
    
    /// Applies the initial data snapshots to the collection view.
    private func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlayerComparison>()
        if let player1, let player2 {
            snapshot.appendSections([.main])
            snapshot.appendItems(viewModel.createData(player1: player1, player2: player2))
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CompareColumnViewController: UICollectionViewDelegate {
    // Implement UICollectionViewDelegate methods if necessary.
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompareColumnViewController: UICollectionViewDelegateFlowLayout {
    
    /// Specifies the size for each item in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let player1, let player2 else {
            return CGSize(width: 0, height: 0)
        }
        let itemsCount = CGFloat(viewModel.createData(player1: player1, player2: player2).count)
        return CGSize(width: collectionView.frame.size.width - 16, height: collectionView.frame.size.height / itemsCount)
    }
}
