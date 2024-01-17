//
//  ParameterViewController.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// Protocol for delegates of ParameterViewController to handle updated search parameters.
protocol ParameterViewControllerDelegate: AnyObject {
    func didUpdateParameters(ageRange: ClosedRange<Int>,
                             abilityRange: ClosedRange<Int>,
                             potentialRange: ClosedRange<Int>,
                             sortOption: SortOption)
}
/// Protocol for handling value changes in a custom range slider.
protocol CustomRangeSliderDelegate: AnyObject {
    func rangeSliderValueChanged(_ rangeSlider: CustomRangeSlider, minVal: CGFloat, maxVal: CGFloat, isMinKob: Bool)
}

/// A view controller that allows users to set search parameters for filtering data.
final class ParameterViewController: UIViewController {

    // MARK: - Constants
    
    enum Constants {
        static let contentStackViewSpacing: CGFloat = 10
        static let contentStackViewPadding: CGFloat = 0
        static let scrollViewPadding: CGFloat = 0
    }
    
    // MARK: - Coordinator
    
    // Coordinator for handling navigation.
    private weak var coordinator: Coordinator?

    // MARK: - UI Components
    
    private let stackViewContainer = UIView()
    
    // ScrollView and StackView for laying out content.
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    // Configurators for the sliders.
    let ageConfig = AgeConfigurator()
    let currentConfig = CurrentConfigurator()
    let potentialConfig = PotentialConfigurator()
    
    // Sliders and picker view that enable user input.
    private lazy var ageSliderView = MinMaxSliderView(
        title: "Age".localized,
        sliderConfigurator: ageConfig
    )
    private lazy var abilitySliderView = MinMaxSliderView(
        title: "Current Ability".localized,
        sliderConfigurator: currentConfig
    )
    private lazy var potentialSliderView = MinMaxSliderView(
        title: "Potential Ability".localized,
        sliderConfigurator: potentialConfig
    )
    private lazy var orderByPickerView = OrderByPickerView(
        title: "Sort By".localized,
        userDefaultsManager: userDefaultsManager
    )
        
    private lazy var ageStepperView = MinMaxAdjusterView(
        title: "Age".localized,
        config: ageConfig
    )
    private lazy var abilityStepperView = MinMaxAdjusterView(
        title: "Current Ability".localized,
        config: currentConfig
    )
    private lazy var potentialStepperView = MinMaxAdjusterView(
        title: "Potential Ability".localized,
        config: potentialConfig
    )
    
    // UserDefaults manager for storing and retrieving parameter data.
    let userDefaultsManager: UserDefaultsManaging
    
    // Delegate to notify about parameter updates.
    weak var delegate: ParameterViewControllerDelegate?

    // MARK: - Initializers
    
    /// Initializes a new instance of the ParameterViewController.
    /// - Parameters:
    ///   - coordinator: An optional coordinator for handling navigation.
    ///   - userDefaultsManager: A manager for interacting with UserDefaults.
    init(
        coordinator: Coordinator? = nil,
        userDefaultsManager: UserDefaultsManaging
    ) {
        self.userDefaultsManager = userDefaultsManager
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showCoreDataLoadingError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadParameters()
    }
    
    // MARK: - Setup Methods
    private func setupStackViewContainer() {
        view.addSubview(stackViewContainer)
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for stackViewContainer
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Add scrollView to stackViewContainer
        stackViewContainer.addSubview(scrollView)
        // Setup scrollView constraints within stackViewContainer here...
        
        scrollView.anchor(
            top: stackViewContainer.safeAreaLayoutGuide.topAnchor,
            verticalTopSpace: Constants.scrollViewPadding,
            bottom: stackViewContainer.safeAreaLayoutGuide.bottomAnchor,
            verticalBottomSpace: Constants.scrollViewPadding,
            left: stackViewContainer.safeAreaLayoutGuide.leftAnchor,
            horizontalLeftSpace: Constants.scrollViewPadding,
            right: stackViewContainer.safeAreaLayoutGuide.rightAnchor,
            horizontalRightSpace: Constants.scrollViewPadding
        )
        
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = Constants.contentStackViewSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.anchor(
            top: scrollView.topAnchor,
            verticalTopSpace: Constants.contentStackViewPadding,
            bottom: scrollView.bottomAnchor,
            verticalBottomSpace: Constants.contentStackViewPadding,
            left: scrollView.leftAnchor,
            horizontalLeftSpace: Constants.contentStackViewPadding,
            right: scrollView.rightAnchor,
            horizontalRightSpace: Constants.contentStackViewPadding,
            width: self.view.frame.width
        )
        
        // Add subviews to content stack view
        
        if UIAccessibility.isVoiceOverRunning {
            contentStackView.addArrangedSubview(ageStepperView)
            contentStackView.addArrangedSubview(abilityStepperView)
            contentStackView.addArrangedSubview(potentialStepperView)
        } else {
            contentStackView.addArrangedSubview(ageSliderView)
            contentStackView.addArrangedSubview(abilitySliderView)
            contentStackView.addArrangedSubview(potentialSliderView)
        }
        
        contentStackView.addArrangedSubview(orderByPickerView)
    }
    
    // MARK: - Error Handling
    
    /// Displays an error alert if there is an issue with the picker view.
    private func showPickerViewError() {
        orderByPickerView.onPickerViewError = { [weak self] error in
            self?.showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
        }
    }

    /// Displays an error alert if there is an issue loading data from CoreData.
    private func showCoreDataLoadingError() {
        orderByPickerView.onLoadingError = { [weak self] error in
            self?.showAlert(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
        }
    }
    
    // MARK: - Dismiss and Notify
    
    /// Dismisses the modal view controller (ParameterViewController) and notifies the delegate of updated parameters.
    @objc private func dismissModal() {
        
        var ageRange: ClosedRange<Int>?
        var abilityRange: ClosedRange<Int>?
        var potentialRange: ClosedRange<Int>?

        if UIAccessibility.isVoiceOverRunning {
            ageRange = extractRange(from: ageStepperView)
            abilityRange = extractRange(from: abilityStepperView)
            potentialRange = extractRange(from: potentialStepperView)
            
        } else {
            ageRange = extractRange(from: ageSliderView)
            abilityRange = extractRange(from: abilitySliderView)
            potentialRange = extractRange(from: potentialSliderView)
        }
        
        guard let ageRange, let abilityRange, let potentialRange else {
            showAlert(
                title: "Invalid input".localized,
                message: "Try again".localized,
                preferredStyle: .alert
            )
            return
        }
        
        let sortOption = determineSortOption(from: orderByPickerView.currentSortOption?.rawValue.localized ?? "")
        
        notifyDelegateOfParameterUpdate(
            ageRange: ageRange,
            abilityRange: abilityRange,
            potentialRange: potentialRange,
            sortOption: sortOption
        )
        
        coordinator?.dismissModal(animated: true)
    }
    
    // MARK: - Parameter Extraction and Notification
    
    /// Extracts the range values from a given MinMaxSliderView.
    /// - Parameter sliderView: The MinMaxSliderView from which to extract the range.
    /// - Returns: A ClosedRange<Int> if valid values are entered, nil otherwise.
    private func extractRange(from view: MinMaxValuable) -> ClosedRange<Int>? {
        
        guard let minVal = Int(view.minTextField.text ?? ""),
              let maxVal = Int(view.maxTextField.text ?? "") else {
            return nil
        }
        
        return minVal...maxVal
    }

    /// Notifies the delegate of updated parameter values.
    /// - Parameters:
    ///   - ageRange: The selected age range.
    ///   - abilityRange: The selected ability range.
    ///   - potentialRange: The selected potential range.
    ///   - sortOption: The selected sorting option.
    private func notifyDelegateOfParameterUpdate(
        ageRange: ClosedRange<Int>,
        abilityRange: ClosedRange<Int>,
        potentialRange: ClosedRange<Int>,
        sortOption: SortOption
    ) {
        
        delegate?.didUpdateParameters(
            ageRange: ageRange,
            abilityRange: abilityRange,
            potentialRange: potentialRange,
            sortOption: sortOption
        )
    }
    
    /// Determines the SortOption based on a string value.
    /// - Parameter selectedOption: The string representation of the selected sort option.
    /// - Returns: The corresponding SortOption value.
    private func determineSortOption(from selectedOption: String) -> SortOption {
        // Logic to convert the selected option string to a SortOptions enum value
        // Example:
        switch selectedOption {
        case "age (ascending)".localized:
            return .ageAscending
        case "current ability (ascending)".localized:
            return .currentAbilityAscending
        case "potential ability (ascending)".localized:
            return .potentialAbilityAscending
        case "age (descending)".localized:
            return .ageDescending
        case "current ability (descending)".localized:
            return .currentAbilityDescending
        case "potential ability (descending)".localized:
            return .potentialAbilityDescending
        default:
            return .nothing
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the user interface of the view controller.
    private func setupUI() {
        setupStackViewContainer()
        view.backgroundColor = .systemBackground
        setupNavBar()
    }
    
    /// Sets up the navigation bar for the view controller.
    private func setupNavBar() {
        self.title = "Set Parameter".localized
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    }
    
    /// Loads and sets the parameters from UserDefaults into the UI elements.
    private func loadParameters() {
        let parameters = userDefaultsManager.loadSearchParameters()
        
        // Update your sliders with these loaded values
        // Using lowerBound and upperBound to access the range values
        ageSliderView.setValues(
            minValue: CGFloat(
                parameters.ageRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.ageRange.upperBound
            )
        )
        abilitySliderView.setValues(
            minValue: CGFloat(
                parameters.abilityRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.abilityRange.upperBound
            )
        )
        potentialSliderView.setValues(
            minValue: CGFloat(
                parameters.potentialRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.potentialRange.upperBound
            )
        )
        
        ageStepperView.setValues(
            minValue: CGFloat(
                parameters.ageRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.ageRange.upperBound
            )
        )
        abilityStepperView.setValues(
            minValue: CGFloat(
                parameters.abilityRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.abilityRange.upperBound
            )
        )
        potentialStepperView.setValues(
            minValue: CGFloat(
                parameters.potentialRange.lowerBound
            ),
            maxValue: CGFloat(
                parameters.potentialRange.upperBound
            )
        )
        
        // Assuming you have an instance of OrderByPickerView named orderByPickerView
        orderByPickerView.setCurrentSortOption(parameters.sortOption) { error in
            if let error {
                self.showAlert(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            }
        }
    }
}
