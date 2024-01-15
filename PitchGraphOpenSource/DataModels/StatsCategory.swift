//
//  StatsCategory.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// Represents the different categories of player statistics that can be displayed in the `StatsViewController`.
///
/// This enumeration is used to define and manage the segments in the segmented control within the `StatsViewController`.
/// Each case corresponds to a specific category of player statistics, such as Technical, Mental, Physical, or Goalkeeping.
/// The raw values of the enum cases are aligned with the segment indexes of the segmented control.
///
/// - technical: Represents the technical category of player statistics.
/// - mental: Represents the mental category of player statistics.
/// - physical: Represents the physical category of player statistics.
/// - goalkeeping: Represents the goalkeeping category of player statistics, specific to goalkeepers.
public enum StatsCategory: Int {
    case technical = 0
    case mental = 1
    case physical = 2
    case goalkeeping = 3
    case hidden = 4
}
