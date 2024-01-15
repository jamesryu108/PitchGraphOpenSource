//
//  MinMaxSliderView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

public protocol MinMaxValuable {
    var minTextField: UITextField { get }
    var maxTextField: UITextField { get }
}

/// A custom UIView class that encapsulates a min-max slider functionality.
/// It consists of a title label, two text fields for minimum and maximum values, and a custom range slider.
final class MinMaxSliderView: UIView, MinMaxValuable {
    
    // MARK: - Constants

    /// Constants used for layout and default settings.
    private struct Constants {
        static let textFieldWidth: CGFloat = 50
        static let sliderWidth: CGFloat = 180
        static let stackViewSpacing: CGFloat = 16
        static let verticalStackViewSpacing: CGFloat = 8
        static let leadingPadding: CGFloat = 8
        static let rightPaddingViewWidth: CGFloat = 0
    }
    
    // MARK: - UI Components

    /// Title label displayed above the slider.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Text field for inputting the minimum value.
    let minTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    /// Text field for inputting the maximum value.
    let maxTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    /// Custom range slider for selecting a value range.
    let slider: CustomRangeSlider = {
        let slider = CustomRangeSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: - Properties

    /// Current minimum value of the slider.
    var minValue: CGFloat

    /// Current maximum value of the slider.
    var maxValue: CGFloat
    
    var sliderConfigurator: SliderConfiguring
    
    // MARK: - Initializers

    /// Initializes the MinMaxSliderView with a title and initial min and max values.
    /// - Parameters:
    ///   - title: "Name of which parameter you want to set range for"
    ///   - minValue: Minimum value possible for the parameter
    ///   - maxValue: Maximum value possible for the parameter
    init(title: String, sliderConfigurator: SliderConfiguring) {
        self.sliderConfigurator = sliderConfigurator
        self.minValue = sliderConfigurator.minValue
        self.maxValue = sliderConfigurator.maxValue
        super.init(frame: .zero)
        
        updateTextFields()
        setupView()
        setupTitleLabel(with: title)
        setupDelegates()
        slider.setMinAndMaxValues(minValue: minValue, maxValue: maxValue)
        adjustFontsSize()
        setupFontSizeAdjustmentObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods

    /// Sets up the title label with the provided text.
    private func setupTitleLabel(with text: String) {
        titleLabel.text = text
    }
    
    /// Configures delegates for text fields and the slider.
    private func setupDelegates() {
        minTextField.delegate = self
        maxTextField.delegate = self
        slider.delegate = self
    }
    
    /// Updates the text fields with the current min and max values.
    private func updateTextFields() {
        minTextField.text = "\(Int(minValue))"
        maxTextField.text = "\(Int(maxValue))"
    }
    
    /// Called when the view is moved to a superview; used to update the slider values.
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        slider.setMinAndMaxValues(
            minValue: minValue,
            maxValue: maxValue
        )
    }
    
    /// Sets up the view by adding and configuring subviews and their constraints.
    private func setupView() {
        // Configure constraints for min and max text fields and the slider.
        minTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth).isActive = true
        slider.widthAnchor.constraint(equalToConstant: Constants.sliderWidth).isActive = true
        maxTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth).isActive = true
        
        // A view to be used as right padding in the slider stack view.
        let rightPaddingView = UIView()
        rightPaddingView.translatesAutoresizingMaskIntoConstraints = false
        rightPaddingView.widthAnchor.constraint(equalToConstant: Constants.rightPaddingViewWidth).isActive = true
        
        // Horizontal stack view to layout the min text field, slider, max text field, and padding view.
        let sliderStackView = UIStackView(arrangedSubviews: [minTextField, slider, maxTextField, rightPaddingView])
        sliderStackView.axis = .horizontal
        sliderStackView.spacing = Constants.stackViewSpacing
        sliderStackView.distribution = .fillProportionally
        
        // Vertical stack view to layout the title label and slider stack view.
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, sliderStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Constants.verticalStackViewSpacing
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        
        // Add the vertical stack view to the main view and set up its constraints.
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - CustomRangeSliderDelegate

extension MinMaxSliderView: CustomRangeSliderDelegate {
    
    /// Called when the value of the range slider changes.
    func rangeSliderValueChanged(_ rangeSlider: CustomRangeSlider, minVal: CGFloat, maxVal: CGFloat, isMinKob: Bool) {
        // Update the min or max value and text field based on which knob was moved.
        if isMinKob {
            let minIntValue = Int(round(minVal * rangeSlider.absoluteMaxValue))
            minValue = CGFloat(minIntValue)
            minTextField.text = "\(minIntValue)"
        } else {
            let maxIntValue = Int(round(maxVal * rangeSlider.absoluteMaxValue))
            maxValue = CGFloat(maxIntValue)
            maxTextField.text = "\(maxIntValue)"
        }
    }
}

// MARK: - UITextFieldDelegate

extension MinMaxSliderView: UITextFieldDelegate {
    
    /// Called when text editing in a text field ends.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text, let value = Double(text), value >= slider.absoluteMinValue, value <= slider.absoluteMaxValue else {
            showAlertWithMessage("\("Please enter a valid number between".localized) \(slider.absoluteMinValue) \("and".localized) \(slider.absoluteMaxValue)")
            resetTextField(textField)
            return
        }
        
        // Handle value changes in min and max text fields.
        if textField == minTextField {
            guard value <= slider.maxValue * slider.absoluteMaxValue else {
                showAlertWithMessage("Minimum value cannot be greater than the current maximum value".localized)
                resetTextField(textField)
                return
            }
            slider.setMinValue(Double(value))
        } else if textField == maxTextField {
            guard value >= slider.minValue * slider.absoluteMaxValue else {
                showAlertWithMessage("Maximum value cannot be less than the current minimum value".localized)
                resetTextField(textField)
                return
            }
            slider.setMaxValue(Double(value))
        }
    }
    
    /// Resets the text field to its corresponding slider value.
    private func resetTextField(_ textField: UITextField) {
        textField.text = (textField == minTextField) ? "\(Int(slider.absoluteMinValue))" : "\(Int(slider.absoluteMaxValue))"
    }
    
    /// Displays an alert with the given message.
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Invalid Input".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
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

// MARK: - Public Methods

extension MinMaxSliderView {
    
    /// Sets the min and max values and updates the text fields and slider.
    func setValues(minValue: CGFloat, maxValue: CGFloat) {
        self.minValue = minValue
        self.maxValue = maxValue
        
        updateTextFields()
        slider.setMinValue(Double(minValue))
        slider.setMaxValue(Double(maxValue))
    }
}

extension MinMaxSliderView: FontAdjustable {
    func adjustFontsSize() {
        adjustFontSize(
            for: titleLabel,
            minFontSize: 25,
            maxFontSize: 31,
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
