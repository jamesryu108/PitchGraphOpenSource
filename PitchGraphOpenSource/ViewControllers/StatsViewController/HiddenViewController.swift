//
//  HiddenViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `HiddenViewController` displays and manages a collection view of hidden attributes for one or two players
final class HiddenViewController: BaseCollectionViewController {

    // MARK: - Properties
    
    private var viewModel: HiddenConfigurable
    let statsMode: StatsMode

    // MARK: - Initializers
    
    init(
        viewModel: HiddenConfigurable,
        statsMode: StatsMode
    ) {
        self.viewModel = viewModel
        self.statsMode = statsMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        processData()
        setupUI()
    }
    
    // MARK: - Binding
    
    /// Set up binding to subscribe to the `HiddenViewModel`
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
    
    // MARK: - UI Setup methods
    
    /// Sets up UI components specific to `HiddenViewController`.
    private func setupUI() {
        setupHiddenCV()
    }
    
    /// Configures the collection view for displaying hidden attributes.
    private func setupHiddenCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HiddenAttributeCell.self, forCellWithReuseIdentifier: HiddenAttributeCell.reuseIdentifier)
        collectionView.register(TwoHiddenAttributeCell.self, forCellWithReuseIdentifier: TwoHiddenAttributeCell.reuseIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = self.statsMode == .appMode ? .systemBackground : .systemGray6
    }
    
    /// Processes the player data to prepare it for display.
    private func processData() {
        viewModel.processData()
    }
    
    /// Updates collection view once new data becomes available.
    private func updateView() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension HiddenViewController {
    
    /// Returns the number of items in the collection view section.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hiddenAttributesForPlayer1.count
    }
    
    /// Provides the cell for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attribute1 = viewModel.hiddenAttributesForPlayer1[indexPath.item]
        
        if let attribute2 = viewModel.hiddenAttributesForPlayer2?[indexPath.item] {
            // Cell configuration for two players' data.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoHiddenAttributeCell.reuseIdentifier, for: indexPath) as? TwoHiddenAttributeCell else {
                fatalError("TwoHiddenAttributeCell does not exist")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HiddenAttributeCell.reuseIdentifier, for: indexPath) as? HiddenAttributeCell else {
                fatalError("HiddenAttributeCell does not exist")
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

extension HiddenViewController {
    /// Specifies the size for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
