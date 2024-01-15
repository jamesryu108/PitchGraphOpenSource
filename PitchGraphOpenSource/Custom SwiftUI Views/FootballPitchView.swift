//
//  FootballPitchView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation
import SwiftUI

struct FootballPitchView: View {
    
    private enum Constants {
        static let minFontSize: CGFloat = 18
        static let maxFontSize: CGFloat = 30
        static let circleSize: CGFloat = 32
    }
    
    @State var positionInfo: [String]? = nil
    @ObservedObject var viewModel: FootballPitchViewModel
    @State private var positionsArray: [String] = []
    let height: CGFloat
    init(
        positionInfo: [String]? = nil,
        viewModel: FootballPitchViewModel = FootballPitchViewModel(),
        height: CGFloat
    ) {
        self.positionInfo = positionInfo
        self.viewModel = viewModel
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Eligible Positions".localized)
                        .adjustableFont(
                            minFontSize: Constants.minFontSize,
                            maxFontSize: Constants.maxFontSize,
                            textStyle: .body,
                            isBlackWeight: true
                        )
                        .padding(8)
                        .accessibilityLabel(Text("Eligible Positions".localized))
                        .accessibilityHint(Text("Shows player's eligible positions".localized))
                    Spacer()
                }
                ZStack {
                    PitchView(
                        width: geometry.size.width,
                        height: height - 50
                    )
                    .clipShape(RoundedCorners(radius: (height - 50) / 32, corners: [.bottomLeft, .bottomRight]))
                    ForEach(viewModel.positions) { id in
                        PlayerObject(label: id.name, color: .blue, size: Constants.circleSize, eligible: positionsArray.contains(id.name) ? true : false)
                            .offset(
                                x: (id.x * geometry.size.width) / 2,
                                y: (id.y * geometry.size.height) / 2
                            )
                    }
                }
            }
        }
        .onAppear(perform: {
            positionsArray = viewModel.extractPositions(from: positionInfo ?? [])
        })
    }
}
