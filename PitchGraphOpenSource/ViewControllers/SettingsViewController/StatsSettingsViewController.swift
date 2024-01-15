//
//  StatsSettingsViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import Combine
import UIKit

final class StatsSettingsViewController: UIViewController {

    // MARK: - Constants
    
    enum Constants {
        static let numberOfSections: Int = 1
        static let collectionViewPadding: CGFloat = 0
        static let totalOptions: CGFloat = 4
        static let collectionViewHeight: CGFloat = 50 * totalOptions
        static let cellHeight: CGFloat = 50
        static let minimumLineSpacing: CGFloat = 0
        static let minimumInteritemSpacing: CGFloat = 0
    }
    
    // MARK: - Coordinator
    
    /// Coordinator responsible for navigation and flow control from this view controller.
    private var coordinator: StatsSettingsCoordinator?
    
    // MARK: - View Models
    
    let viewModel: StatsSettingsViewModel
    
    // MARK: - UI Views

    private lazy var collectionView: UICollectionView = setupCollectionView()
    
    /// A container view for displaying the content of the selected statistics category.
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Combine AnyCancellable
    
    /// Set of AnyCancellable for managing Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UserDefaults
    
    private let userDefaults: UserDefaultsManaging
    
    // MARK: - VCs
    private lazy var technicalViewController = TechnicalViewController(
        viewModel: viewModel,
        statsMode: .appMode
    )
    
    // MARK: - Initializers
    init(
        coordinator: StatsSettingsCoordinator,
        viewModel: StatsSettingsViewModel,
        userDefaults: UserDefaultsManaging
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.userDefaults = userDefaults
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkColorTheme()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    deinit {
        removeTechnicalViewController()
    }
    
    // MARK: - Set up binding
    
    private func setupBinding() {
        viewModel.$selectedOptionIndex
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] _ in
                guard let self else {
                    return
                }
                collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper UI functions

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        loadSelectedOption()
        setupNavBar()
        view.addSubview(collectionView)
        setupVC()
        setupConstraints()
    }
    
    private func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StatsSettingCollectionViewCell.self, forCellWithReuseIdentifier: StatsSettingCollectionViewCell.reuseIdentifier)
        return collectionView
    }
    
    private func setupConstraints() {
        
        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: Constants.collectionViewPadding,
            left: view.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: Constants.collectionViewPadding,
            right: view.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: Constants.collectionViewPadding,
            height: Constants.collectionViewHeight
        )
        
        containerView.anchor(top: collectionView.bottomAnchor, verticalTopSpace: 8, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, verticalBottomSpace: 8, left: self.view.safeAreaLayoutGuide.leftAnchor, horizontalLeftSpace: 8, right: self.view.safeAreaLayoutGuide.rightAnchor, horizontalRightSpace: 8
        )
    }

    private func setupVC() {

        self.view.addSubview(containerView)
        addChildViewController(technicalViewController, to: containerView)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: Constants.cellHeight) // Adjust the size as needed
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        return layout
    }
    
    /// Sets up the navigation bar with title and left bar button item.
    private func setupNavBar() {
        self.title = "Stat Theme Settings".localized
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    }
    
    private func loadSelectedOption() {
        Task {
            viewModel.selectedOptionIndex = await userDefaults.loadSelectedOptionIndex(for: .selectedOptionIndex) ?? IndexPath(row: 0, section: 0)
        }
    }
    
    private func removeTechnicalViewController() {
        removeChildViewController(technicalViewController)
    }
    
    // MARK: - Dismiss Modal
    
    /// Dismisses the modal view controller.
    @objc private func dismissModal() {
        coordinator?.dismissModal(animated: true)
    }
    
    func cleanUp() {
        coordinator?.coordinatorDidFinish()
    }
}

extension StatsSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatsSettingCollectionViewCell.reuseIdentifier, for: indexPath) as? StatsSettingCollectionViewCell else {
            fatalError("StatsSettingCollectionViewCell does not exist")
        }
        
        let isSelected = indexPath == viewModel.selectedOptionIndex
        cell.configureCell(with: viewModel.options[indexPath.row], isSelected: isSelected, selectedOptionIndex: indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOptionIndex = viewModel.selectedOptionIndex
        if let selectedOptionIndex {
            collectionView.deselectItem(at: selectedOptionIndex, animated: true)
        }
        
        // Select the new cell
        viewModel.selectedOptionIndex = indexPath
        userDefaults.saveSelectedOptionIndex(indexPath, for: .selectedOptionIndex)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.options.count
    }
}
