//
//  MentalViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `MentalViewController` manages the display of mental attributes of soccer players in a collection view. It supports showing data for one or two players.
final class MentalViewController: BaseCollectionViewController {
    
    // MARK: - View model

    private var viewModel: MentalConfigurable
    let statsMode: StatsMode
    // MARK: - Initializers

    /// Initializes a new instance of the view controller with given player data.
    init(viewModel: MentalConfigurable, statsMode: StatsMode) {
        self.viewModel = viewModel
        self.statsMode = statsMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    /// Called after the controller's view is loaded into memory.
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

    /// Sets up UI components specific to `MentalViewController`.
    private func setupUI() {
        setupMentalCV()
    }

    /// Configures the collection view for displaying mental attributes.
    private func setupMentalCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MentalAttributeCell.self, forCellWithReuseIdentifier: MentalAttributeCell.reuseIdentifier)
        collectionView.register(TwoMentalAttributeCell.self, forCellWithReuseIdentifier: TwoMentalAttributeCell.reuseIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = self.statsMode == .appMode ? .systemBackground : .systemGray6
    }

    /// Processes the player data and prepares it for display.
    private func processData() {
        viewModel.processData()
    }
    
    private func updateView() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension MentalViewController {
    
    /// Returns the number of items in each section of the collection view.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mentalAttributesForPlayer1.count
    }
    
    /// Configures the cell for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attribute1 = viewModel.mentalAttributesForPlayer1[indexPath.row]
        
        if let attribute2 = viewModel.mentalAttributesForPlayer2?[indexPath.item] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoMentalAttributeCell.reuseIdentifier, for: indexPath) as? TwoMentalAttributeCell else {
                fatalError("TwoMentalAttributeCell does not exist")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MentalAttributeCell.reuseIdentifier, for: indexPath) as? MentalAttributeCell else {
                fatalError("MentalAttributeCell does not exist")
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

extension MentalViewController {
    
    /// Specifies the size for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
