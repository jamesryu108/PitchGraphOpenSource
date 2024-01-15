//
//  StatsMode.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// This is an enum that indicates whether the StatsViewController will be added to the PDF or used in the app. Based on this value, the background color of the StatsViewController can change.
public enum StatsMode {
    case appMode
    case pdfMode
    case compareMode
}
