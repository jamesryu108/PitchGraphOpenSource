//
//  ReusableCellConfiguring.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

// Protocol to configure reusable cells with a reuse identifier and font size adjustment observer.
protocol ReusableCellConfiguring {
    static var reuseIdentifier: String { get }
    func setupFontSizeAdjustmentObserver()
}

// Protocol to configure reusable views with a font size adjustment observer.
protocol ReusableViewConfiguring {
    func setupFontSizeAdjustmentObserver()
}
