//
//  MinMaxAdjusterView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

protocol MinMaxAdjusterViewConfiguring {
    var minValue: CGFloat { get }
    var maxValue: CGFloat { get }
}

struct CurrentVoiceConfigurator: MinMaxAdjusterViewConfiguring {
    var minValue: CGFloat { return 0 }
    var maxValue: CGFloat { return 200 }
}

class MinMaxAdjusterView: UIView, MinMaxValuable {
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minTextField = UITextField()
    let maxTextField = UITextField()
    private let minStepper = UIStepper()
    private let maxStepper = UIStepper()
    
    private let minValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Minimum value".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Maximum value".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var config: SliderConfiguring

    /// Current minimum value of the slider.
    var minValue: CGFloat

    /// Current maximum value of the slider.
    var maxValue: CGFloat
    
    private var title: String
    
    // MARK: - Initializer
    init(title: String, config: SliderConfiguring) {
        self.config = config
        self.title = title
        self.minValue = config.minValue
        self.maxValue = config.maxValue
        super.init(frame: .zero)
        setupViews()
        setupTitleLabel(with: title)
        setupDelegates()
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the title label with the provided text.
    private func setupTitleLabel(with text: String) {
        titleLabel.text = text
    }
    
    private func setupDelegates() {
        minTextField.delegate = self
        maxTextField.delegate = self
    }

    // MARK: - Setup Views
    private func setupViews() {
        configureTextField(minTextField, defaultValue: Int(config.minValue))
        configureTextField(maxTextField, defaultValue: Int(config.maxValue))

        configureStepper(minStepper, minValue: Double(config.minValue), maxValue: Double(config.maxValue))
        configureStepper(maxStepper, minValue: Double(config.minValue), maxValue: Double(config.maxValue))

        // Create Row Views
        let minRowView = createRowView(
            textField: minTextField,
            stepper: minStepper
        )
        let maxRowView = createRowView(
            textField: maxTextField,
            stepper: maxStepper
        )

        // Main Stack View
        let mainStackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                minValueLabel,
                minRowView,
                maxValueLabel,
                maxRowView
            ]
        )
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)

        // Constraints for mainStackView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add target actions for steppers
        minStepper.addTarget(self, action: #selector(minStepperChanged(_:)), for: .valueChanged)
        maxStepper.addTarget(self, action: #selector(maxStepperChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Create Row View
    private func createRowView(label: UILabel, textField: UITextField, stepper: UIStepper) -> UIView {
        let rowStackView = UIStackView(arrangedSubviews: [label, textField, stepper])
        rowStackView.axis = .horizontal
        rowStackView.spacing = 10
        return rowStackView
    }

    // MARK: - Configuration Helpers
    private func configureTextField(_ textField: UITextField, defaultValue: Int) {
        textField.text = "\(defaultValue)"
        textField.borderStyle = .roundedRect
    }

    private func configureStepper(_ stepper: UIStepper, minValue: Double, maxValue: Double) {
        stepper.minimumValue = minValue
        stepper.maximumValue = maxValue
        stepper.stepValue = 1
        stepper.value = minValue
    }

    private func createRowView(textField: UITextField, stepper: UIStepper) -> UIView {
        let rowView = UIStackView(arrangedSubviews: [textField, stepper])
        rowView.axis = .horizontal
        rowView.spacing = 10
        return rowView
    }
    
    // MARK: - Stepper Actions
    @objc private func minStepperChanged(_ stepper: UIStepper) {
        let newMinValue = Int(stepper.value)
        if let currentMaxValue = Int(maxTextField.text ?? ""), newMinValue < currentMaxValue {
            minTextField.text = "\(newMinValue)"
        } else {
            // Reset the stepper to its previous value
            stepper.value = Double(newMinValue - 1)
        }
    }

    @objc private func maxStepperChanged(_ stepper: UIStepper) {
        let newMaxValue = Int(stepper.value)
        if let currentMinValue = Int(minTextField.text ?? ""), newMaxValue > currentMinValue {
            maxTextField.text = "\(newMaxValue)"
        } else {
            // Reset the stepper to its previous value
            stepper.value = Double(newMaxValue + 1)
        }
    }
}

extension MinMaxAdjusterView {
    
    /// Sets the min and max values and updates the text fields and slider.
    func setValues(minValue: CGFloat, maxValue: CGFloat) {
        self.minValue = minValue
        self.maxValue = maxValue
        
        updateTextFields()
        
        minStepper.value = minValue
        maxStepper.value = maxValue
    }
    
    /// Updates the text fields with the current min and max values.
    private func updateTextFields() {
        minTextField.text = "\(Int(minValue))"
        maxTextField.text = "\(Int(maxValue))"
    }
}

extension MinMaxAdjusterView: UITextFieldDelegate {
    
    /// Called when text editing in a text field ends.
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let value = Double(text), value >= config.minValue, value <= config.maxValue else {
            showAlertWithMessage("\("Please enter a valid number between".localized) \(config.minValue) \("and".localized) \(config.maxValue)")
            resetTextField(textField)
            return
        }
        
        if textField == minTextField {
            guard value < maxValue else {
                showAlertWithMessage("Minimum value cannot be greater than or equal to the current maximum value".localized)
                resetTextField(textField)
                return
            }
            minValue = value
            minStepper.value = Double(value)
        } else if textField == maxTextField {
            guard value > minValue else {
                showAlertWithMessage("Maximum value cannot be less than or equal to the current minimum value".localized)
                resetTextField(textField)
                return
            }
            maxValue = value
            maxStepper.value = Double(value)
        }
    }

    /// Resets the text field to its corresponding value.
    private func resetTextField(_ textField: UITextField) {
        textField.text = (textField == minTextField) ? "\(Int(minValue))" : "\(Int(maxValue))"
    }

    /// Displays an alert with the given message.
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Invalid Input".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        // Assuming a utility method to find the view controller
        if let parentViewController = self.findViewController() {
            parentViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Validates the input in the text field to ensure it's numeric.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    /// Dismisses the keyboard when the return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MinMaxAdjusterView: FontAdjustable {
    func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: 25,
            maxFontSize: 31,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: minValueLabel,
            minFontSize: 12,
            maxFontSize: 18,
            forTextStyle: .body,
            isBlackWeight: true
        )
        adjustFontSize(
            for: maxValueLabel,
            minFontSize: 12,
            maxFontSize: 18,
            forTextStyle: .body,
            isBlackWeight: true
        )
    }
    
    func setupFontSizeAdjustmentObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustFontsSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
