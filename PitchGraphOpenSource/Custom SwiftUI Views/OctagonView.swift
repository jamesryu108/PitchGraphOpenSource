//
//  OctagonView.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation
import SwiftUI
import UIKit
struct OctagonView: View {
	@ObservedObject var viewModel: OctagonViewModel
	@State var player1Data: PlayerData?
	@State var player2Data: PlayerData?
	let height: CGFloat

	init(
		height: CGFloat,
		player1Data: PlayerData?,
		player2Data: PlayerData? = nil,
		viewModel: OctagonViewModel
	) {
		self.height = height
		self.player1Data = player1Data
		self.player2Data = player2Data
		self.viewModel = viewModel
	}

	var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Attribute Analysis".localized)
					.adjustableFont(minFontSize: 18, maxFontSize: 30, textStyle: .body, isBlackWeight: true)
					.padding(.top, 8)
					.padding(.leading, 8)
					.accessibilityLabel(Text("Attribute Analysis".localized))
					.accessibilityHint(Text("Provides an analysis of player attributes using an octagon".localized))
				Spacer()
			}
			Spacer()
			ZStack {
				Octagon()
					.fill(Color.green)
					.frame(width: 300, height: 300)
				Octagon()
					.fill(Color.lightGreen)
					.frame(width: 240, height: 240)
				Octagon()
					.fill(Color.yellow)
					.frame(width: 180, height: 180)
				Octagon()
					.fill(Color.orange)
					.frame(width: 120, height: 120)
				Octagon()
					.fill(Color.red)
					.frame(width: 60, height: 60)
				ZStack {

					if !viewModel.firstPlayerOctagonData.isEmpty {
						EvaluationOctagon(octagonRatings: viewModel.firstPlayerOctagonData, progress: viewModel.progress)
							.fill(Color.blue)
							.opacity(0.3)
							.frame(width: 300, height: 300)
							.animation(.easeInOut(duration: 2), value: viewModel.progress) // Add animation modifier
					}
					if !viewModel.secondPlayerOctagonData.isEmpty {
						EvaluationOctagon(octagonRatings: viewModel.secondPlayerOctagonData, progress: viewModel.progress)
							.fill(Color.pink)
							.opacity(0.3)
							.frame(width: 300, height: 300)
							.animation(.easeInOut(duration: 2), value: viewModel.progress) // Add animation modifier
					}
					if !viewModel.firstPlayerOctagonData.isEmpty {
						ForEach(0..<8) { index in
							VStack {
								Text(viewModel.firstPlayerOctagonData[index].category)
									.font(.system(size: 10))
								VStack(spacing: 0) {
									Text("\(viewModel.firstPlayerOctagonData[index].rating.rounded(.up), specifier: "%.2f")")
										.attributeBox(backgroundColor: Color.blue)
									if !viewModel.secondPlayerOctagonData.isEmpty {
										Text("\(viewModel.secondPlayerOctagonData[index].rating.rounded(.up), specifier: "%.2f")")
											.attributeBox(backgroundColor: Color.pink)
									}
								}
							}
							.position(viewModel.pointOnOctagon(for: index, radius: 180, center: CGPoint(x: 150, y: 150)))
						}
						.frame(width: 300, height: 300)
					}
				}
			}
			Spacer()
			HStack {
				if let player1Name = player1Data?.name {
					LegendColorBox(color: Color.blue, text: player1Name)
						.accessibilityElement(children: .combine)
						.accessibilityLabel(Text("First player's name: \(player1Name)"))
						.accessibilityHint(Text("Displays the name of the first player"))
				}
				if let player2Data = player2Data, !viewModel.secondPlayerOctagonData.isEmpty {
					LegendColorBox(color: Color.pink, text: player2Data.name ?? "")
						.accessibilityElement(children: .combine)
						.accessibilityLabel(Text("Second player's name: \(player2Data.name ?? "")"))
						.accessibilityHint(Text("Displays the name of the second player"))
				}
				Spacer()
			}
			.padding([.bottom, .horizontal]) // Add padding if needed
			//Spacer()
		}
		.frame(height: height)
		//.background(Color.blue)
		.onReceive(viewModel.timer) { time in // Subscribe to the timer publisher
			if viewModel.count < 10 { // Check if the count is less than 10
				viewModel.count += 1 // Increment the count
				viewModel.progress += 0.1
			} else {
				viewModel.timer.upstream.connect().cancel() // Cancel the timer
			}
		}
		.onAppear(perform: {
			if let player1Data {
				viewModel.createOctagonData(firstPlayerData: player1Data, secondPlayerData: player2Data)
			}
		})
	}
}

struct AdjustableFontModifier: ViewModifier {

	@Environment(\.sizeCategory) var sizeCategory

	var minFontSize: CGFloat
	var maxFontSize: CGFloat
	var textStyle: UIFont.TextStyle
	var isBlackWeight: Bool

	func body(content: Content) -> some View {
		content.font(self.adjustedFont)
	}

	private var adjustedFont: Font {
		let preferredFont = UIFont.preferredFont(forTextStyle: textStyle)
		let clampedFontSize = min(max(preferredFont.pointSize, minFontSize), maxFontSize)
		let font: UIFont

		if isBlackWeight {
			let fontDescriptor = preferredFont.fontDescriptor.withSymbolicTraits(.traitBold) ?? preferredFont.fontDescriptor
			font = UIFont(descriptor: fontDescriptor, size: clampedFontSize)
		} else {
			font = preferredFont.withSize(clampedFontSize)
		}

		return Font(font)
	}
}

extension View {
	func adjustableFont(minFontSize: CGFloat, maxFontSize: CGFloat, textStyle: UIFont.TextStyle, isBlackWeight: Bool) -> some View {
		self.modifier(AdjustableFontModifier(minFontSize: minFontSize, maxFontSize: maxFontSize, textStyle: textStyle, isBlackWeight: isBlackWeight))
	}
}
