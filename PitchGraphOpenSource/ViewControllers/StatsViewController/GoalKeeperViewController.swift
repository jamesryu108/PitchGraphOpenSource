//
//  GoalKeeperViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `GoalKeepingViewController` displays and manages a collection view of goalkeeping attributes for one or two players.
final class GoalKeepingViewController: BaseCollectionViewController {
    
    // MARK: - Properties

    private var viewModel: GoalKeeperConfigurable
    let statsMode: StatsMode
    // MARK: - Initializers

    init(
        viewModel: GoalKeeperConfigurable,
        statsMode: StatsMode
    ) {
        self.viewModel = viewModel
        self.statsMode = statsMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        processData()
        setupUI()
    }
        
    // MARK: - Binding
    private func setupBinding() {
        viewModel.subscribeToSelectedOptionIndexChanges { [weak self] indexPath in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    // MARK: - UI Setup Methods

    /// Sets up UI components specific to `GoalKeepingViewController`.
    private func setupUI() {
        setupGoalKeeperCV()
    }

    /// Configures the collection view for displaying goalkeeping attributes.
    private func setupGoalKeeperCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GoalKeeperAttributeCell.self, forCellWithReuseIdentifier: GoalKeeperAttributeCell.reuseIdentifier)
        collectionView.register(TwoGoalKeeperAttributeCell.self, forCellWithReuseIdentifier: TwoGoalKeeperAttributeCell.reuseIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = self.statsMode == .appMode ? .systemBackground : .systemGray6
    }

    /// Processes the player data and prepares it for display.
    private func processData() {
        viewModel.processData()
    }
    
    /// Updates collection view once new data becomes available.
    private func updateView() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension GoalKeepingViewController {
    
    /// Returns the number of items in the collection view section.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.goalkeeperAttributesForPlayer1.count
    }
    
    /// Provides the cell for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attribute1 = viewModel.goalkeeperAttributesForPlayer1[indexPath.item]
        
        if let attribute2 = viewModel.goalkeeperAttributesForPlayer2?[indexPath.item] {
            // Cell configuration for two players' data.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoGoalKeeperAttributeCell.reuseIdentifier, for: indexPath) as? TwoGoalKeeperAttributeCell else {
                fatalError("TwoGoalKeeperAttributeCell does not exist")
            }
            
            let player1Score = attribute1.score
            let player2Score = attribute2.score
            
            cell.configure(
                player1Score: player1Score,
                attributeName: attribute1.name.capitalized,
                player2Score: player2Score,
                index: indexPath.row,
                option: viewModel.selectedOptionIndex?.row ?? 0
            )
            return cell
        } else {
            // Cell configuration for single player data.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalKeeperAttributeCell.reuseIdentifier, for: indexPath) as? GoalKeeperAttributeCell else {
                fatalError("GoalKeeperAttributeCell does not exist")
            }
            cell.configure(
                with: attribute1,
                index: indexPath.row,
                option: viewModel.selectedOptionIndex?.row ?? 0
            )
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GoalKeepingViewController {
    
    /// Specifies the size for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}

