//
//  CloudStatusViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Combine
import UIKit

// A view controller that displays the status of network connectivity and iCloud account status.
final class CloudStatusViewController: UIViewController {
    
    // MARK: - Constants
    
    /// Constants for layout configuration.
    enum Constants {
        static let padding: CGFloat = 20
        static let cellHeight: CGFloat = 50
        static let headHeight: CGFloat = 50
        static let collectionViewPadding: CGFloat = 0
    }
    
    // MARK: - Combine AnyCancellable
    
    /// Set of AnyCancellable for managing Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI elements
    
    /// Collection view for displaying cloud status.
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    /// Activity indicator to show while checking network status.
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    /// Label for displaying a message during network status check.
    private lazy var statusMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Checking network connection".localized
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.isHidden = true // Hidden initially
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    
    // MARK: - ViewModel
    
    /// ViewModel to manage and provide the cloud status data.
    let viewModel: CloudStatusViewModel
    
    // MARK: - Coordinator
    
    /// Coordinator responsible for navigation and flow control from this view controller.
    private var coordinator: CloudStatusCoordinator?
    
    // MARK: - Initializers
    
    /// Initializes the CloudStatusViewController with a coordinator and viewModel.
    init(
        coordinator: CloudStatusCoordinator,
        viewModel: CloudStatusViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    /// Called after the view controller has loaded its view hierarchy.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupRefresher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cleanUp()
    }
    
    // MARK: - Helper UI functions
    
    /// Sets up the main user interface components.
    private func setupUI() {
        view.backgroundColor = .systemBackground
  
        view.addSubviews(collectionView, activityIndicator, statusMessageLabel)
        
        setupCollectionView()
        setupNavBar()
    }
    
    /// Sets up and configures the collection view.
    private func setupCollectionView() {
        
        // Use Auto Layout to set up the constraints for the collection view.
        
        setConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CloudStatusCell.self, forCellWithReuseIdentifier: CloudStatusCell.reuseIdentifier)
        collectionView.register(CloudStatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CloudStatusHeaderView.reuseIdentifier)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
 
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        
        return layout
    }
    
    private func setConstraints() {
        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: Constants.collectionViewPadding,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            verticalBottomSpace: Constants.collectionViewPadding,
            left: view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: Constants.collectionViewPadding,
            right: view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: Constants.collectionViewPadding
        )
        
        activityIndicator.anchor(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
        
        statusMessageLabel.anchor(
            top: activityIndicator.bottomAnchor,
            verticalTopSpace: 10,
            centerX: view.centerXAnchor
        )
    }
    
    /// Sets up the navigation bar configuration.
    private func setupNavBar() {
        title = "iCloud Status".localized
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissModal)
        )
    }
    
    private func setupRefresher() {
        refreshControl.addTarget(self, action: #selector(refreshCloudStatus), for: .valueChanged)
    }

    // MARK: - Setup Bindings
    
    /// Sets up bindings to the ViewModel.
    private func setupBindings() {
        // Subscribe to ViewModel's cloudData for updates.
        viewModel.$cloudData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.collectionView.reloadData() }
            .store(in: &cancellables)
        
        // Subscribe to ViewModel's cloudError for handling errors.
        viewModel.$cloudError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error, let self = self {
                    self.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to ViewModel's isNetworkCheckInProgress for updating UI.
        viewModel.$isNetworkCheckInProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inProgress in
                self?.statusMessageLabel.isHidden = !inProgress
                inProgress ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    /// Handles errors by displaying an alert to the user.
    private func handleError(_ error: CloudStatusError) {
        let message: String
        switch error {
        case .networkUnavailable:
            message = "The network is currently unavailable. Please check your connection and try again.".localized
        case .iCloudAccountUnavailable:
            message = "Unable to access iCloud Account. Please check your iCloud settings and try again.".localized
        case .restrictedNetwork:
            message = "Network access is restricted. Please check your network settings.".localized
        case .unknownError:
            message = "An unknown error occurred. Please try again later.".localized
        }
        
        let alert = UIAlertController(
            title: "Error".localized,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK".localized,
                style: .default
            )
        )
        present(
            alert,
            animated: true
        )
    }
    
    // MARK: - Dismiss Modal
    /// Dismisses the view controller.
    @objc private func dismissModal() {
        coordinator?.dismissModal(animated: true)
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
    
    // MARK: - Helper method for UIRefreshControl
    @MainActor
    @objc private func refreshCloudStatus() {
        viewModel.makeNetworkCalls()
        self.refreshControl.endRefreshing()
    }
}

// MARK: - UICollectionView DataSource and Delegate

extension CloudStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Returns the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.cloudData.count
    }
    
    /// Returns the number of items in each section of the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cloudData[section].cloudStatus.count
    }
    
    /// Provides a configured cell for each item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CloudStatusCell.reuseIdentifier, for: indexPath) as? CloudStatusCell else {
            fatalError("Unable to dequeue CloudStatusCell")
        }
        let status = viewModel.cloudData[indexPath.section].cloudStatus[indexPath.row]
        cell.configure(with: status)
        return cell
    }
    
    /// Provides a configured header view for each section in the collection view.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CloudStatusHeaderView.reuseIdentifier, for: indexPath) as? CloudStatusHeaderView else {
            fatalError("Unable to dequeue CloudStatusHeaderView")
        }
        headerView.titleLabel.text = viewModel.cloudData[indexPath.section].name
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CloudStatusViewController: UICollectionViewDelegateFlowLayout {
    
    /// Returns the size for each item in the collection view.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width - (
            Constants.padding * 2
        )
        return CGSize(
            width: width,
            height: Constants.cellHeight
        )
    }
    
    /// Returns the size for each header in the collection view.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let width = collectionView.bounds.width - (
            Constants.padding * 2
        )
        return CGSize(
            width: width,
            height: Constants.headHeight
        )
    }
}
