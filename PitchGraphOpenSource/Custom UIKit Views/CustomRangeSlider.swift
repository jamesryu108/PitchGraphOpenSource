//
//  CustomRangeSlider.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

/// A custom range slider view that allows selection of a minimum and maximum value within a range.
final class CustomRangeSlider: UIView {

    // Constants defining the UI elements' sizes and appearances.
    private enum Constants {
        static var knobSize: CGFloat {
            UIScreen.main.bounds.width <= 375 ? 30 : 40 // Smaller size for narrow screens such as iPhone SE
        }
        static let knobCornerRadius: CGFloat = Constants.knobSize / 2 // Need to divide 2 to make the knob circular
        static let trackHeight: CGFloat = 12
        static let trackOffset: CGFloat = 2
        
        static let unselectedTrackColor = UIColor.systemGray6
        static let selectedTrackColor = UIColor.systemGray
        static let knobColor = UIColor.systemBlue
    }
    
    // Delegate for sending range slider value change events.
    weak var delegate: CustomRangeSliderDelegate?

    // UI components of the slider.
    private let minKnobView = UIView()
    private let maxKnobView = UIView()
    private let trackView = UIView()
    private let selectedTrackView = UIView()
    private let unselectedTrackView = UIView()

    // Constraints for dynamically positioning the knobs.
    private var minKnobXConstraint: NSLayoutConstraint!
    private var maxKnobXConstraint: NSLayoutConstraint!

    // The absolute minimum and maximum values the slider can represent.
    var absoluteMinValue: CGFloat = 0.0
    var absoluteMaxValue: CGFloat = 1.0
    
    // The currently selected minimum and maximum values.
    var minValue: CGFloat = 0.0 {
        didSet { updateTrackViews() }
    }
    var maxValue: CGFloat = 1.0 {
        didSet { updateTrackViews() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    /// Sets the minimum and maximum values for the slider and updates the knob positions.
        /// - Parameters:
        ///   - minValue: The new minimum value.
        ///   - maxValue: The new maximum value.
    func setMinAndMaxValues(minValue: CGFloat, maxValue: CGFloat) {
        self.minValue = minValue
        self.maxValue = maxValue

        absoluteMinValue = minValue
        absoluteMaxValue = maxValue
        
        DispatchQueue.main.async {
            self.updateKnobPositions()
        }
    }

    /// Updates the positions of the knobs based on the current min and max values.
    private func updateKnobPositions() {
        // Ensure the total range isn't zero to avoid division by zero
        let totalRange = max(absoluteMaxValue - absoluteMinValue, 1)
        
        // Calculate the position of the min knob based on the minValue
        let minPos = ((minValue * absoluteMaxValue) / totalRange) * frame.width
        minKnobXConstraint.constant = validatedKnobPosition(for: minPos)
     
        // Calculate the position of the max knob based on the maxValue
        let maxPos = ((maxValue * absoluteMaxValue) / totalRange) * frame.width
        maxKnobXConstraint.constant = validatedKnobPosition(for: maxPos)

        // Animate the knob position changes.
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Ensure the layout updates immediately with new constraints and using UIView.animate to animate the process in 0.3 seconds
        }
        
        updateTrackViews() // Update the track views to reflect the new knob positions
    }
    
    /// Sets up the views and constraints of the slider.
    private func setupViews() {
        // Setup the main track view
        trackView.backgroundColor = Constants.unselectedTrackColor
        addSubview(trackView)

        // Setup the unselected and selected track views
        unselectedTrackView.backgroundColor = Constants.unselectedTrackColor
        selectedTrackView.backgroundColor = Constants.selectedTrackColor

        trackView.addSubview(unselectedTrackView)
        trackView.addSubview(selectedTrackView)

        // Setup min and max knob views
        minKnobView.backgroundColor = Constants.knobColor
        maxKnobView.backgroundColor = Constants.knobColor

        addSubview(minKnobView)
        addSubview(maxKnobView)

        minKnobView.layer.cornerRadius = Constants.knobCornerRadius
        maxKnobView.layer.cornerRadius = Constants.knobCornerRadius

        minKnobView.translatesAutoresizingMaskIntoConstraints = false
        maxKnobView.translatesAutoresizingMaskIntoConstraints = false

        minKnobXConstraint = minKnobView.centerXAnchor.constraint(equalTo: leadingAnchor)
        maxKnobXConstraint = maxKnobView.centerXAnchor.constraint(equalTo: leadingAnchor)

        NSLayoutConstraint.activate([
            minKnobView.widthAnchor.constraint(equalToConstant: Constants.knobSize),
            minKnobView.heightAnchor.constraint(equalToConstant: Constants.knobSize),
            minKnobView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            maxKnobView.widthAnchor.constraint(equalToConstant: Constants.knobSize),
            maxKnobView.heightAnchor.constraint(equalToConstant: Constants.knobSize),
            maxKnobView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            minKnobXConstraint,
            maxKnobXConstraint
        ])

        let minPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMinPan(_:)))
        let maxPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMaxPan(_:)))

        minKnobView.addGestureRecognizer(minPanGesture)
        maxKnobView.addGestureRecognizer(maxPanGesture)
    }

    /// Lays out subviews, adjusting the frame of the track view.
    override func layoutSubviews() {
        super.layoutSubviews()
        trackView.frame = CGRect(x: 0, y: frame.height / 2 - Constants.trackOffset, width: frame.width, height: Constants.trackHeight)
        updateTrackViews()
    }

    /// Updates the frames of the selected and unselected track views based on the knob positions.
    private func updateTrackViews() {
        let minPosition = minKnobXConstraint.constant
        let maxPosition = maxKnobXConstraint.constant

        selectedTrackView.frame = CGRect(x: minPosition, y: 0, width: maxPosition - minPosition, height: Constants.trackHeight)
        unselectedTrackView.frame = CGRect(x: 0, y: 0, width: minPosition, height: Constants.trackHeight)
    }

    /// Handles pan gesture for the minimum value knob.
    @objc private func handleMinPan(_ gesture: UIPanGestureRecognizer) {
        // ... Existing pan handling logic
        handlePan(gesture, isMinKnob: true)
        delegate?.rangeSliderValueChanged(self, minVal: minValue, maxVal: maxValue, isMinKob: true)
    }
    
    /// Handles pan gesture for the maximum value knob.
    @objc private func handleMaxPan(_ gesture: UIPanGestureRecognizer) {
        // ... Existing pan handling logic
        handlePan(gesture, isMinKnob: false)
        delegate?.rangeSliderValueChanged(self, minVal: minValue, maxVal: maxValue, isMinKob: false)
    }
    
    /// Handles the pan gesture for both min and max knobs.
       /// - Parameters:
       ///   - gesture: The pan gesture recognizer.
       ///   - isMinKnob: A Boolean indicating whether the gesture is for the min knob.
    private func handlePan(_ gesture: UIPanGestureRecognizer, isMinKnob: Bool) {
        let translation = gesture.translation(in: self)
        let newX = calculateNewPosition(with: translation, for: isMinKnob)
        updateKnobPosition(newX, for: isMinKnob)

        // Resetting the translation to avoid compounding
        gesture.setTranslation(.zero, in: self)
        updateTrackViews()

        // Notify delegate about the value change
        delegate?.rangeSliderValueChanged(
            self,
            minVal: minValue,
            maxVal: maxValue,
            isMinKob: isMinKnob
        )
    }

    /// Calculates the new horizontal position for a slider knob.
    ///
    /// This function computes the new horizontal position for a minimum knob (e.g. Blue knob) based on the user's drag gesture.
    /// It ensures taht the position remains within the bounds of the slider.
    /// - Parameters:
    ///   - translation: This is the translation point from the user's pan gesture, indicating how far the knob should move from its current position.
    ///   - isMinKnob: A Boolean value indicating whether the knob moved by the user is the minimum knob (blue one) or not. If `true` then the minimum knob was moved. Otherwise, the maximum knob was moved.
    /// - Returns: A CGFloat value representing the new position of the knob on the slider.
    private func calculateNewPosition(with translation: CGPoint, for isMinKnob: Bool) -> CGFloat {
        let currentX = isMinKnob ? minKnobXConstraint.constant : maxKnobXConstraint.constant
        var newX = currentX + translation.x

        // Constrain newX to be within the slider bounds
        newX = max(0, min(newX, frame.width))

        // Apply step if necessary and enforce min/max separation
        return enforceValueBounds(for: newX, isMinKnob: isMinKnob)
    }

    /// This function adjusts the value output by `calculateNewPosition(with: for:)` to make sure that it respects the slider's value constraints. It also will take into account the step intervals and minimum/maximum value separation rules defined for the slider.
    ///
    /// The function calculates a new value for the knob by dividing the value output by `calculateNewPosition(with: for:)` the width of each step interval (Which is determined by dividin the slider's width by the `absoluteMaxValue` property of the `CustomRangeSlider` class.) The value is then rounded to make sure it aligns with a step interval.
    /// - Parameters:
    ///   - newX: A CGFloat value that should be the new x position for the knob.
    ///   - isMinKnob: A Boolean value indicating whether the knob being moved is the minimum value knob or not. `True` means that the knob is minimum knob otherwise it is maximum knob.
    /// - Returns: A CGFloat value representing the new position of the knob on the slider.
    private func enforceValueBounds(for newX: CGFloat, isMinKnob: Bool) -> CGFloat {
        let stepWidth = frame.width / absoluteMaxValue
        var newValue = round(newX / stepWidth)

        if isMinKnob {
            newValue = min(newValue, (maxValue * absoluteMaxValue) - 1)
        } else {
            newValue = max(newValue, (minValue * absoluteMaxValue) + 1)
        }

        return newValue * stepWidth
    }

    /// Updates the position of the knobs on the slider.
    /// The function also makes sure if haptic feedback should be generated based on the new position of the knob. It will be generated if the knob reaches the either end.
    /// - Parameters:
    ///   - newX: A CGFloat value representing the new x position for the knob.
    ///   - isMinKnob: A Boolean value indicating whether the knob being updated is the minimum value or maximum value knob. If `true` then the it is a minimum knob. Otherwise, it is a maximum knob.
    private func updateKnobPosition(_ newX: CGFloat, for isMinKnob: Bool) {
        if isMinKnob {
            minKnobXConstraint.constant = validatedKnobPosition(for: newX)
            minValue = newX / frame.width
            checkForHapticFeedback(for: minValue)
        } else {
            maxKnobXConstraint.constant = validatedKnobPosition(for: newX)
            maxValue = newX / frame.width
            checkForHapticFeedback(for: maxValue)
        }
    }

    /// Checks and generates haptic feedback if the slider's value reaches its bounds.
    /// - Parameter value: A CGFloat value that represents the current x position of the knob. (minValue or maxValue)
    private func checkForHapticFeedback(for value: CGFloat) {
        if (value == absoluteMinValue || value == absoluteMaxValue) {
            generateHapticFeedback()
        }
    }
    
    /// Calculates a safe position for a knob to avoid NaN values.
        /// - Parameter value: The proposed new position value.
        /// - Returns: A safe position value.
    private func validatedKnobPosition(for value: CGFloat) -> CGFloat {
        return value.isNaN ? 0 : value
    }
    
    /// Sets a new minimum value for the slider.
        /// - Parameter value: The new minimum value.
    func setMinValue(_ value: Double) {
        let newValue = min(value, absoluteMaxValue)
        self.layoutIfNeeded()
        let position = (newValue - absoluteMinValue) / (absoluteMaxValue - absoluteMinValue) * frame.width
        minKnobXConstraint.constant = validatedKnobPosition(for: position)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Ensure the layout updates immediately with new constraints
        }
        minValue = position / frame.width
        updateTrackViews()
    }
    
    /// Sets a new maximum value for the slider.
        /// - Parameter value: The new maximum value.
    func setMaxValue(_ value: Double) {
        let newValue = min(value, absoluteMaxValue)
        self.layoutIfNeeded()
        let position = (newValue - absoluteMinValue) / (absoluteMaxValue - absoluteMinValue) * frame.width
        maxKnobXConstraint.constant = validatedKnobPosition(for: position)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Ensure the layout updates immediately with new constraints
        }
        maxValue = position / frame.width
        updateTrackViews()
    }
        
    /// Generates haptic feedback using the device's physical feedback mechanism.
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
