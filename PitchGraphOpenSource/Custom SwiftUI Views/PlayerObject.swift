//
//  PlayerObject.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI

struct PlayerObject: View {
    var label: String
    var color: Color
    var size: CGFloat
    var eligible: Bool
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size, alignment: .center)
            Text(label)
                .font(.system(size: 10))
        }
        .opacity(eligible ? 1.0 : 0.2)
    }
}
