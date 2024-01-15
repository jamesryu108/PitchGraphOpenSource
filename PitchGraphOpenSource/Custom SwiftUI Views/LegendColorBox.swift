//
//  LegendColorBox.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI

struct LegendColorBox: View {
    var color: Color
    var text: String

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(text)
                .adjustableFont(minFontSize: 12, maxFontSize: 18, textStyle: .caption1, isBlackWeight: true)
                .foregroundColor(.primary)
        }
    }
}
