//
//  Octagon.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation
import SwiftUI

struct Octagon: Shape {
    func path(in rect: CGRect) -> Path {
        let sides = 8
        let angle = 2 * .pi / CGFloat(sides)
        let length = min(rect.width, rect.height) * 0.5
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        return Path { path in
            for i in 0..<sides {
                let x = center.x + length * cos(CGFloat(i) * angle)
                let y = center.y + length * sin(CGFloat(i) * angle)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
}

struct EvaluationOctagon: Shape, Animatable {
    var octagonRatings: [OctagonData] = []
    var progress: CGFloat = 0 // Add this property
    var animatableData: CGFloat { // Conform to Animatable protocol
        get { progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let sides = 8
        let angle = 2 * .pi / CGFloat(sides)
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        return Path { path in
            for i in 0..<sides {
                let length = min(rect.width, rect.height) * 0.5 * (octagonRatings[i].rating / 20) * progress // Use progress to scale length
                let x = center.x + length * cos(CGFloat(i) * angle)
                let y = center.y + length * sin(CGFloat(i) * angle)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
}
