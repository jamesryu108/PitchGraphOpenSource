//
//  BaseCollectionViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// `BaseCollectionViewController` is a generic view controller for managing a collection view.
class BaseCollectionViewController: UIViewController {
    
    // MARK: - Constants

    /// Constants defining UI layout and collection view properties.
    enum Constants {
        static let padding: CGFloat = 0
        static let numberOfItemsInSection: Int = 1
        static let cellHeight = 50
        static let cellWidth = 100
    }
    
    // MARK: - UI Components

    /// Collection view managed by the controller.
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Lifecycle Methods

    /// Called after the controller's view is loaded into memory. Sets up the collection view.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Setup UI Methods

    private func setupUI() {
        
    }
    
    /// Sets up the collection view and its constraints.
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        collectionView.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor, verticalTopSpace: Constants.padding,
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor, verticalBottomSpace: Constants.padding,
            left: self.view.safeAreaLayoutGuide.leftAnchor, horizontalLeftSpace: Constants.padding,
            right: self.view.safeAreaLayoutGuide.rightAnchor, horizontalRightSpace: Constants.padding
        )
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension BaseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// Specifies the number of items in each section of the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }

    /// Provides the cell to be displayed at each index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Note: In a real implementation, you should dequeue and configure the cell.
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {

    /// Specifies the size of each item in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
}

