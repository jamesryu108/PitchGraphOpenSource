//
//  OrderPickerView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// `OrderByPickerView` is a custom UIView that contains a UIPickerView and a UILabel.
/// It allows users to select a sorting option from a predefined list.
final class OrderByPickerView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let titleLabelFontSize: CGFloat = 16
        static let titleLabelLeading: CGFloat = 8
        static let pickerViewTopSpacing: CGFloat = 8
    }
    
    // MARK: - UI Components
    let pickerView = UIPickerView()
    let titleLabel = UILabel()
    
    // MARK: - Properties
    /// An array of `SortOption` representing the different sorting criteria available.
    let sortOptions = SortOption.allCases
    
    /// The currently selected sort option.
    var currentSortOption: SortOption?
    
    /// An instance of `UserDefaultsManager` for managing user defaults.
    private let userDefaultsManager: UserDefaultsManaging
    
    /// A closure that gets called when an error occurs in loading the initial sort option.
    var onLoadingError: ((Error) -> Void)?
    
    /// A closure that gets called when an error occurs while picking from UIPickerView
    var onPickerViewError: ((Error) -> Void)?
    
    // MARK: - Initializers
    /// Initializes a new `OrderByPickerView` with a title, `UserDefaultsManager`, and an optional frame.
    /// - Parameters:
    ///   - title: The title to be displayed above the picker view.
    ///   - userDefaultsManager: An instance of `UserDefaultsManager` for managing user defaults.
    ///   - frame: The frame of the view. Default is `.zero`.
    init(title: String, userDefaultsManager: UserDefaultsManaging, frame: CGRect = .zero) {
        self.userDefaultsManager = userDefaultsManager
        super.init(frame: frame)
        configureView(with: title)
        setInitialSortOption()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    /// Required initializer for initializing from a nib or storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(with title: String) {
        setupTitleLabel(with: title)
        setupPickerView()
    }
    
    // MARK: - Setup Methods
    /// Sets up the title label with specified text.
    /// - Parameter title: The text to be set as the title of the label.
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFontSize)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTitleLabelConstraints()
    }
    
    /// Sets up the layout constraints for the titleLabel.
    ///
    /// This method configures the auto layout constraints for the titleLabel within the `OrderByPickerView`.
    /// It positions the titleLabel at the top of the view and aligns it to the leading edge.
    /// The trailing constraint ensures that the titleLabel does not exceed the width of the view.
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }
    
    /// Sets the current sorting option and saves it to user defaults. Notifies completion handler upon completion.
    /// This method first selects the specified sort option in the picker view, then attempts to save this option to user defaults.
    /// If the save operation is successful or fails, the completion handler is called with `nil` or the respective error.
    ///
    /// - Parameters:
    ///   - sortOption: The `SortOption` to be set as the current selection in the picker view.
    ///   - completion: An optional closure that is called when the save operation completes. The closure takes an optional `Error` as its parameter.
    ///                 If the save operation is successful, `nil` is passed to this closure; otherwise, the error is passed.
    func setCurrentSortOption(_ sortOption: SortOption, completion: ((Error?) -> Void)? = nil) {
        let row = sortOptions.firstIndex(of: sortOption) ?? 0
        pickerView.selectRow(row, inComponent: 0, animated: false)
        
        Task.init {
            do {
                try await userDefaultsManager.save(sortOption.rawValue, for: UserDefaultsKey.selectedSortOption)
            } catch {
                completion?(error)
            }
        }
    }
    
    /// Sets up the picker view, including its delegate, dataSource, and constraints.
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        setupPickerViewConstraints()
        setDefaultPickerValue()
    }
    
    /// Sets up the layout constraints for the pickerView.
    ///
    /// This method configures the auto layout constraints for the pickerView within the `OrderByPickerView`.
    /// It positions the pickerView just below the titleLabel and stretches it to the leading and trailing edges of the view.
    /// The bottom constraint anchors the pickerView to the bottom of the view, ensuring it expands to fill the available vertical space.
    private func setupPickerViewConstraints() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.pickerViewTopSpacing),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Sets the default value of the picker view based on a predefined sort option.
    private func setDefaultPickerValue() {
        if let defaultRowIndex = sortOptions.firstIndex(of: SortOption(rawValue: "nothing") ?? .nothing) {
            pickerView.selectRow(defaultRowIndex, inComponent: 0, animated: false)
            currentSortOption = sortOptions[defaultRowIndex]
        }
    }
    
    /// Sets the initial sort option based on a saved value in user defaults, if available.
    private func setInitialSortOption() {
        do {
            guard let savedOptionString = try userDefaultsManager.load(key: UserDefaultsKey.selectedSortOption.rawValue) as? String else {
                return
            }
            let savedOption = SortOption.from(stringValue: savedOptionString) ?? .nothing
            let row = sortOptions.firstIndex(of: savedOption) ?? 0
            pickerView.selectRow(row, inComponent: 0, animated: false)
        } catch {
            // Handle the error, e.g., log it or show an alert
            onLoadingError?(error)
        }
    }
}

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate
extension OrderByPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    /// Returns the number of components in the picker view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Returns the number of rows in the given component of the picker view.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }
    
    /// Provides the title for each row in the picker view.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row].localizedString
    }
    
    /// Handles the selection of a row in the picker view. Updates the current sort option and saves it to user defaults.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = sortOptions[row]
        currentSortOption = SortOption(rawValue: selectedOption.rawValue)
        Task.init {
            do {
                try await userDefaultsManager.save(selectedOption.rawValue, for: UserDefaultsKey.selectedSortOption)
            } catch {
                onPickerViewError?(error)
            }
        }
    }
}

extension OrderByPickerView: FontAdjustable {
    func adjustFontsSize() {
        adjustFontSize(for: titleLabel, minFontSize: 25, maxFontSize: 31, forTextStyle: .body, isBlackWeight: true)
    }
    
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
