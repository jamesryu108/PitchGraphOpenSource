//
//  StatsViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-14.
//

import Combine
import UIKit

/// A view controller responsible for managing and displaying player statistics across various categories like Technical, Mental, Physical, and Goalkeeping.
final class StatsViewController: UIViewController {
    
    // MARK: - Constants

    /// Defines constants used for UI layout, such as padding and label sizes.
    private enum Constants {
        static let padding: CGFloat = 8
        static let labelHeight: CGFloat = 32
        static let minFontSize: CGFloat = 18
        static let maxFontSize: CGFloat = 30
    }
    
    // MARK: - UI Components

    /// A label for displaying the title of the current statistics section.
    lazy private var progressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(statsMode != .compareMode ? statsViewModel.playerData.name ?? "" : "")\(statsViewModel.statsType[selectedIndexSegment].localized) \("Stats".localized)"
        return label
    }()
    
    /// A segmented control allowing the user to select different categories of statistics.
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    /// A container view for displaying the content of the selected statistics category.
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
  
    /// Manages user preferences and settings.
    private let userDefaults: UserDefaultsManaging
    
    /// The index of the selected segment in the segmented control.
    private let selectedIndexSegment: Int
    
    /// Enum value representing the current mode of statistics display.
    private let statsMode: StatsMode
        
    // ViewModel instances for each category of player statistics.
    
    let technicalViewModel: TechnicalConfigurable
    let physicalViewModel: PhysicalConfigurable
    let mentalViewModel: MentalConfigurable
    let goalKeeperViewModel: GoalKeeperConfigurable
    let hiddenViewModel: HiddenConfigurable
    let statsViewModel: StatsViewModel
    
    // Child view controllers for each statistics category.
    lazy private(set) var technicalVC = TechnicalViewController(
        viewModel: technicalViewModel,
        statsMode: statsMode
    )
    lazy private(set) var mentalVC = MentalViewController(
        viewModel: mentalViewModel,
        statsMode: statsMode
    )
    lazy private(set) var physicalVC = PhysicalViewController(
        viewModel: physicalViewModel,
        statsMode: statsMode
    )
    lazy private(set) var goalKeeperVC = GoalKeepingViewController(
        viewModel: goalKeeperViewModel,
        statsMode: statsMode
    )
    lazy private(set) var hiddenVC = HiddenViewController(
        viewModel: hiddenViewModel,
        statsMode: statsMode
    )
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    /// Initializes a `StatsViewController` with the necessary data and configurations.
    init(
        userDefaults: UserDefaultsManaging,
        selectedIndexSegment: Int,
        statsMode: StatsMode,
        technicalViewModel: TechnicalConfigurable,
        mentalViewModel: MentalConfigurable,
        physicalViewModel: PhysicalConfigurable,
        goalKeeperViewModel: GoalKeeperConfigurable,
        hiddenViewModel: HiddenConfigurable,
        statsViewModel: StatsViewModel
    ) {
        self.userDefaults = userDefaults
        self.selectedIndexSegment = selectedIndexSegment
        self.statsMode = statsMode
        self.technicalViewModel = technicalViewModel
        self.mentalViewModel = mentalViewModel
        self.physicalViewModel = physicalViewModel
        self.goalKeeperViewModel = goalKeeperViewModel
        self.hiddenViewModel = hiddenViewModel
        self.statsViewModel = statsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFontSizeAdjustmentObserver()
        bindViewModel()
        segmentedControlValueChanged()
    }
    
    /// Binds properties of the view model to UI components. When `titleText` property of the `statsViewModel` is updated, it will update `progressTitleLabel` with it.
    private func bindViewModel() {
        statsViewModel.$titleText
            .sink { [weak self] title in
                self?.progressTitleLabel.text = title
            }
            .store(in: &cancellables)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    /// Called when the segmented control's value is changed, updating the selected segment and child view controller.
    @objc private func segmentedControlValueChanged() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        statsViewModel.updateSelectedSegment(index: selectedIndex)
        updateChildViewController(segment: selectedIndex)
    }
    
    // MARK: - UI Setup Methods

    /// Establishes the layout constraints for the container view.
    private func setupConstraints() {
        
        view.addSubview(containerView)
        
        containerView.anchor(
            top: segmentedControl.bottomAnchor,
            verticalTopSpace: Constants.padding,
            bottom: view.bottomAnchor,
            verticalBottomSpace: 0,
            left: view.leftAnchor,
            horizontalLeftSpace: 0,
            right: view.rightAnchor,
            horizontalRightSpace: 0
        )
        
        segmentedControl.anchor(
            top: progressTitleLabel.bottomAnchor,
            verticalTopSpace: Constants.padding,
            left: view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.labelHeight
        )
        
        progressTitleLabel.anchor(
            top: view.topAnchor,
            verticalTopSpace: Constants.padding,
            left: view.leftAnchor,
            horizontalLeftSpace: Constants.padding,
            right: view.rightAnchor,
            horizontalRightSpace: Constants.padding,
            height: Constants.labelHeight
        )
    }
    
    /// Configures the overall UI components, including background color, title label, segmented control, and constraints.
    private func setupUI() {
        setupBackgroundColor()
        setupTitleLabel()
        setupSegments()
        setupConstraints()
        adjustFontsSize()
    }
    
    /// Sets the background color based on the current statistics mode.
    private func setupBackgroundColor() {
        view.backgroundColor = statsMode == .appMode ? .systemBackground : .systemGray6
    }
    
    /// Configures the title label and its constraints.
    private func setupTitleLabel() {
        view.addSubview(progressTitleLabel)
    }
    
    /// Sets up the segmented control with appropriate segments and constraints.
    private func setupSegments() {
        view.addSubview(segmentedControl)
        
        for (index, item) in statsViewModel.statsType.enumerated() {
            segmentedControl.insertSegment(
                withTitle: item.localized,
                at: index,
                animated: true
            )
        }
        
        segmentedControl.selectedSegmentIndex = selectedIndexSegment
        segmentedControl.addTarget(self, action: #selector(respondToSegmentValueChange), for: .valueChanged)
    }
    
    /// Responds to changes in segmented control value, updating the title label.
    @objc func respondToSegmentValueChange() {
        progressTitleLabel.text = "\(statsViewModel.playerData.name ?? "") \(statsViewModel.statsType[segmentedControl.selectedSegmentIndex]) \("Stats".localized)"
    }
    
    // MARK: - View Update Methods
    
    /// Updates the child view controller based on the selected segment.
    ///
    /// This method first removes all existing child view controllers from the `children` array.
    /// It then adds the appropriate child view controller to the `containerView` based on the
    /// selected segment. The segment parameter is used to determine which child view controller
    /// should be displayed. Each case in the switch statement corresponds to a different
    /// category of player statistics, and the respective view controller for that category is added.
    ///
    /// - Parameter segment: An integer representing the selected segment index.
    private func updateChildViewController(segment: Int) {
        // Remove all child view controllers
        children.forEach { removeChildViewController($0) }
        // Determine which child view controller to add based on the selected segment
        switch StatsCategory(rawValue: segmentedControl.selectedSegmentIndex) {
        case .technical:
            addChildViewController(technicalVC, to: containerView)
        case .mental:
            addChildViewController(mentalVC, to: containerView)
        case .physical:
            addChildViewController(physicalVC, to: containerView)
        case .goalkeeping:
            addChildViewController(goalKeeperVC, to: containerView)
        case .hidden:
            addChildViewController(hiddenVC, to: containerView)
        case .none: break;
        }
    }
}

// MARK: - FontAdjustable
extension StatsViewController: FontAdjustable {
    /// Adjusts font sizes based on user settings.
    func adjustFontsSize() {
        progressTitleLabel.adjustFontSize(
            for: progressTitleLabel,
            minFontSize: Constants.minFontSize,
            maxFontSize: Constants.maxFontSize,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    /// Sets up an observer to detect changes in user font size preferences.
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustFontsSize), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
}

