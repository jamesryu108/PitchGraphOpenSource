//
//  WhatsNewViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import UIKit

/// A view controller that presents a list of new features or updates in a collection view.
final class WhatsNewViewController: UIViewController, UICollectionViewDataSource {
    
    /// Constants for layout configuration.
    enum Constants {
        /// The height for each cell in the collection view.
        static let collectionViewCellHeight: CGFloat = 30
        /// The padding around the content in each cell.
        static let padding: CGFloat = 8
        /// The inset for sections in the collection view.
        static let sectionInset: CGFloat = 0
        /// The height for each item in the collection view.
        static let cellHeight: CGFloat = 75
    }
    
    // MARK: - View Model
    
    let viewModel: WhatsNewViewModel
    
    // MARK: - Collection View
    
    /// The collection view that displays the updates.
    private lazy var collectionView: UICollectionView = setupCollectionView()
    
    // MARK: - Coordinator
    
    /// The coordinator responsible for navigation logic.
    private var coordinator: WhatsNewCoordinator?
    
    // MARK: - Initializers
    
    /// Initializes the view controller with an optional coordinator.
    /// - Parameter coordinator: The coordinator responsible for navigation logic.
    init(coordinator: WhatsNewCoordinator?,
         viewModel: WhatsNewViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// A required initializer that creates a new instance of the view controller from a coder.
    /// This initializer is not used and will always trigger a runtime error.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    /// Called after the view controller's view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cleanUp()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the main view's background color.
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        setupNavBar()
        setupConstraints()
    }
    
    /// Sets up the navigation bar with a title and a dismiss button.
    private func setupNavBar() {
        title = "\("What's New in".localized) \(viewModel.versionNumber)?"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    }
    
    /// Sets up the collection view with its layout, registers cell and header view classes, and adds it to the view hierarchy.
    private func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            WhatsNewCollectionViewCell.self,
            forCellWithReuseIdentifier: WhatsNewCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            SettingsSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier
        )
        return collectionView
    }
    
    /// Configures the layout for the collection view.
    /// - Returns: A `UICollectionViewFlowLayout` object that defines the layout of the collection view.
    ///
    /// This function creates and configures a `UICollectionViewFlowLayout` object to manage the layout of the cells within the collection view.
    /// The layout is set to a vertical scroll direction.
    /// Each item in the collection view is configured to have a fixed height (`Constants.cellHeight`)
    /// and a dynamic width based on the view's width and the defined padding (`Constants.padding`).
    /// The section insets are set to provide consistent spacing around the sections.
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(
            width: view.frame.size.width - (
                Constants.padding * 2
            ),
            height: Constants.cellHeight
        ) // Customize as needed
        layout.sectionInset = UIEdgeInsets(
            top: Constants.sectionInset,
            left: Constants.sectionInset,
            bottom: Constants.sectionInset,
            right: Constants.sectionInset
        )
        return layout
    }

    /// Sets up constraints for the collection view.
    ///
    /// This function uses a custom `anchor` method to set Auto Layout constraints for the collection view.
    /// It anchors the collection view to the safe area of the `view`, ensuring it respects the top, bottom, left, and right edges of the safe area.
    /// The method configures the collection view to stretch and fill the entire safe area of the view,
    /// with zero space from each edge, providing full coverage within the safe area.
    private func setupConstraints() {
        collectionView.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor, verticalTopSpace: 0,
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor, verticalBottomSpace: 0,
            left: self.view.safeAreaLayoutGuide.leftAnchor, horizontalLeftSpace: 0,
            right: self.view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: 0
        )
    }
    
    // MARK: - UICollectionViewDataSource
    
    /// Returns the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.whatsNewData.count
    }
    
    /// Returns the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.whatsNewData[section].whatsNewDetails.count
    }
    
    /// Asks the data source for the cell that corresponds to the specified item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhatsNewCollectionViewCell.reuseIdentifier, for: indexPath) as? WhatsNewCollectionViewCell else {
            fatalError("WhatsNewCollectionViewCell does not exist")
        }
        
        cell.configure(text: viewModel.whatsNewData[indexPath.section].whatsNewDetails[indexPath.row])
        
        return cell
    }
    
    /// Asks the data source for the view to display in the header of the specified section of the collection view.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier, for: indexPath) as? SettingsSectionHeaderView else {
            fatalError("SettingsSectionHeaderView does not exist")
        }
        
        let section = viewModel.whatsNewData[indexPath.section]
        header.configure(with: "\(section.versionNumber)")
        
        return header
    }
    
    // MARK: - Dismiss Modal
    
    /// Dismisses the view controller when the user taps the 'Done' button.
    @objc private func dismissModal() {
        coordinator?.dismissModal(animated: true)
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

extension WhatsNewViewController: UICollectionViewDelegateFlowLayout {
    
    /// Asks the delegate for the size of the header view in the specified section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: Constants.collectionViewCellHeight
        )
    }
}
