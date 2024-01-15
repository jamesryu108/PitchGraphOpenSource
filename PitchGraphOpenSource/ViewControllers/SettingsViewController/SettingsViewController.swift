//
//  SettingsViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import StoreKit
import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Constants

    /// Constants for layout configuration of the collection view and its elements.
    private enum LayoutConstants {
        static let verticalInset: CGFloat = 20
        static let horizontalInset: CGFloat = 0
        static let itemHeight: CGFloat = 44
    }

    /// Constants for cell and header sizes in the collection view.
    private enum CollectionViewConstants {
        static let cellHeight: CGFloat = 50
        static let headerHeight: CGFloat = 50
    }
    
    weak var coordinator: SettingsCoordinator?
    
    // MARK: - View Models

    /// The view model providing settings data and business logic.
    let viewModel: SettingsViewModel
    
    // MARK: - UI Components

    /// Collection view for displaying the settings options.
    private lazy var collectionView: UICollectionView = configureCollectionView()
    
    // MARK: - Initializers
    init(
        coordinator: SettingsCoordinator,
        viewModel: SettingsViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements of the view controller.
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        view.addSubview(collectionView)
        setupCollectionViewConstraints()
    }
    
    /// Sets up the navigation bar.
    private func setupNavBar() {
        title = "Settings".localized
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissButtonTapped))
    }

    private func setupDismissButton() {
        let dismissButton = UIBarButtonItem(
            title: "Dismiss",
            style: .plain,
            target: self,
            action: #selector(dismissButtonTapped)
        )
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    /// Sets up constraints for the collection view within the main view.
    private func setupCollectionViewConstraints() {
        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: 0,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            verticalBottomSpace: 0,
            left: view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: 0,
            right: view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: 0
        )
    }
    
    private func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: LayoutConstants.verticalInset, left: LayoutConstants.horizontalInset, bottom: LayoutConstants.verticalInset, right: LayoutConstants.horizontalInset)
        layout.itemSize = CGSize(width: view.frame.width - 2 * LayoutConstants.horizontalInset, height: LayoutConstants.itemHeight)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: CollectionViewConstants.headerHeight)
        
        return layout
    }
    
    /// Configures the collection view with layout and registers cell and header types.
    /// - Returns: A configured `UICollectionView` instance.
    private func configureCollectionView() -> UICollectionView {

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier)
        collectionView.register(SettingsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier)
        return collectionView
    }

    @objc private func dismissButtonTapped() {
        
        coordinator?.dismissModal(animated: true)
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

// MARK: - UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
    
    /// Determines the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.settingsData.count
    }
    
    /// Determines the number of items in a given section of the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.settingsData[section].subSection.count
    }
    
    /// Provides a configured cell for an item at the specified index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier, for: indexPath) as? SettingsCollectionViewCell else {
            fatalError("Expected SettingsCollectionViewCell but found a different type")
        }

        let settingData = viewModel.settingsData[indexPath.section].subSection[indexPath.row]
        cell.configure(
            viewModel: SettingsViewModelData(
                title: settingData.title,
                image: settingData.image,
                color: settingData.color
            )
        )
        return cell
    }

    /// Provides a configured header view for a given section.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier, for: indexPath) as? SettingsSectionHeaderView else {
            fatalError("Expected SettingsSectionHeaderView but found a different type")
        }

        let section = viewModel.settingsData[indexPath.section]
        header.configure(with: section.sectionTitle)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
    
    /// Handles the selection of an item in the collection view.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSetting = viewModel.settingsData[indexPath.section].subSection[indexPath.row]
        
        handleSelection(for: selectedSetting.title)
    }

    /// Determines and executes the action based on the selected setting title.
    private func handleSelection(for title: String) {
    
        guard let action = SettingsAction(title: title, versionNumber: viewModel.versionNumber), let navigationController = self.navigationController else { return }

        switch action {
        case .leaveReview:
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        case .stats:
            coordinator?.settingsStatsScreen(navigationController: navigationController)
        case .iCloudStatus:
            coordinator?.cloudScreen(navigationController: navigationController)
        case .whatsNew:
            coordinator?.whatsNewScreen(navigationController: navigationController)
        }
    }
}
