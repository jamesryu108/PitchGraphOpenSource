//
//  PhysicalViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `PhysicalViewController` displays and manages a collection view of physical attributes for one or two players.
final class PhysicalViewController: BaseCollectionViewController {
 
    // MARK: - Properties

    private var viewModel: PhysicalConfigurable
    let statsMode: StatsMode
    // MARK: - Initializers

    /// Initializes a new instance of the view controller with given player data.
    init(viewModel: PhysicalConfigurable, statsMode: StatsMode) {
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
        setupBinding()
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

    /// Sets up UI components specific to `PhysicalViewController`.
    private func setupUI() {
        setupPhysicalCV()
    }

    /// Configures the collection view for displaying physical attributes.
    private func setupPhysicalCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhysicalAttributeCell.self, forCellWithReuseIdentifier: PhysicalAttributeCell.reuseIdentifier)
        collectionView.register(TwoPhysicalAttributeCell.self, forCellWithReuseIdentifier: TwoPhysicalAttributeCell.reuseIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = self.statsMode == .appMode ? .systemBackground : .systemGray6
    }

    /// Processes the player data and maps it to the `attributes` array.
    private func processData() {
        viewModel.processData()
    }
}

// MARK: - UICollectionViewDataSource

extension PhysicalViewController {
    
    /// Returns the number of items in the collection view section.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.physicalAttributesForPlayer1.count
    }
    
    /// Provides the cell for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attribute1 = viewModel.physicalAttributesForPlayer1[indexPath.item]
        
        if let attribute2 = viewModel.physicalAttributesForPlayer2?[indexPath.item] {
            // Cell configuration for two players' data.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoPhysicalAttributeCell.reuseIdentifier, for: indexPath) as? TwoPhysicalAttributeCell else {
                fatalError("Unable to dequeue TwoPhysicalAttributeCell")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhysicalAttributeCell.reuseIdentifier, for: indexPath) as? PhysicalAttributeCell else {
                fatalError("Unable to dequeue PhysicalAttributeCell")
            }
            
            cell.configure(
                with: attribute1,
                index: indexPath.row,
                option: viewModel.selectedOptionIndex?.row ?? 0
            )
            
            return cell
        }
    }
    
    private func updateView() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhysicalViewController {
    
    /// Specifies the size for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
