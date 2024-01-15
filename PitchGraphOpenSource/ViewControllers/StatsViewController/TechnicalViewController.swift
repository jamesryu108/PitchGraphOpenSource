//
//  TechnicalViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

// `TechnicalViewController` manages the display of technical attributes for football players. It supports displaying data for one or two players in a collection view.
final class TechnicalViewController: BaseCollectionViewController {
    
    // MARK: - Properties

    private var viewModel: TechnicalConfigurable
    let statsMode: StatsMode
    
    // MARK: - Initializers

    /// Initializes a new instance of the view controller with given player data.
    init(viewModel: TechnicalConfigurable, statsMode: StatsMode) {
        self.viewModel = viewModel
        self.statsMode = statsMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    /// Called after the controller's view is loaded into memory. Processes data and sets up the UI.
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

    /// Sets up UI components specific to `TechnicalViewController`.
    private func setupUI() {
        self.view.backgroundColor = .systemGray6
        setupTechnicalCV()
    }

    /// Configures the collection view for displaying technical attributes.
    private func setupTechnicalCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TechnicalAttributeCell.self,
            forCellWithReuseIdentifier: TechnicalAttributeCell.reuseIdentifier
        )
        collectionView.register(
            TwoTechnicalCollectionViewCell.self,
            forCellWithReuseIdentifier: TwoTechnicalCollectionViewCell.reuseIdentifier
        )
        
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

extension TechnicalViewController {
    /// Returns the number of items in the collection view section.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.technicalAttributesForPlayer1.count
    }
    
    /// Configures the cell for each item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attribute1 = viewModel.technicalAttributesForPlayer1[indexPath.item]

        if let attribute2 = viewModel.technicalAttributesForPlayer2?[indexPath.item] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoTechnicalCollectionViewCell.reuseIdentifier, for: indexPath) as? TwoTechnicalCollectionViewCell else {
                fatalError("TwoTechnicalCollectionViewCell does not exist")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TechnicalAttributeCell.reuseIdentifier, for: indexPath) as? TechnicalAttributeCell else {
                fatalError("TechnicalAttributeCell does not exist")
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

extension TechnicalViewController {
    /// Specifies the size for each item in the collection view.
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: 30)
    }
}
