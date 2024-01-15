//
//  Configurators.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

protocol SliderConfiguring {
    var minValue: CGFloat { get }
    var maxValue: CGFloat { get }
}

struct AgeConfigurator: SliderConfiguring {
    var minValue: CGFloat { return 0 }
    var maxValue: CGFloat { return 60 }
}

struct CurrentConfigurator: SliderConfiguring {
    var minValue: CGFloat { return 0 }
    var maxValue: CGFloat { return 200 }
}

struct PotentialConfigurator: SliderConfiguring {
    var minValue: CGFloat { return 0 }
    var maxValue: CGFloat { return 200 }
}
