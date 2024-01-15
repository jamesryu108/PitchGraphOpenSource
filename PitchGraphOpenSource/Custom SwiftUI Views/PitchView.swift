//
//  PitchView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import SwiftUI

struct PitchView: View {
    var width: Double
    var height: Double
    var body: some View {
        // Main Pitch
        Rectangle()
            .fill(Color.green)
            .frame(width: width, height: height)
        // Halfway Line
        Path { path in
            path.move(to: CGPoint(x: width / 2, y: 0))
            path.addLine(to: CGPoint(x: width / 2, y: height))
        }
        .stroke(Color.white, lineWidth: 2)
        // Center Circle
        Circle()
            .stroke(Color.white, lineWidth: 2)
            .frame(width: width * 0.2, height: height * 0.2)
            .position(x: width / 2, y: height / 2)
        // Penalty Areas (Left & Right)
        ForEach([0, width], id: \.self) { xPos in
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: width * 0.25, height: height * 0.5)
                .position(x: xPos == 0 ? width * 0.125 : width * 0.875, y: height / 2)
            // Goal Areas (Left & Right)
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: width * 0.125, height: height * 0.25)
                .position(x: xPos == 0 ? width * 0.0625 : width * 0.9375, y: height / 2)
            // Penalty Spots (Left & Right)
            Circle()
                .fill(Color.white)
                .frame(width: 5, height: 5)
                .position(x: xPos == 0 ? width * 0.125 : width * 0.875, y: height / 2)
        }
    }
}
