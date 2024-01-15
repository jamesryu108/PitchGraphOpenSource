//
//  FootballPitchViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// ViewModel responsible for managing football positions on the pitch.
public final class FootballPitchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    /// Published property to hold an array of `Position` objects representing various positions on a football pitch.
    @Published public private(set) var positions: [Position] = [
        Position(
            id: "AM (Right)",
            name: "AMR",
            x: 0.5,
            y: 0.75,
            isEnabled: false
        ),
        Position(
            id: "AM (Left)",
            name: "AML",
            x: 0.5,
            y: -0.75,
            isEnabled: false
        ),
        Position(
            id: "AM (Centre)",
            name: "AMC",
            x: 0.5,
            y: 0,
            isEnabled: false
        ),
        Position(
            id: "Striker (Centre)",
            name: "STC",
            x: 0.9,
            y: 0,
            isEnabled: false
        ),
        Position(
            id: "M (Right)",
            name: "MR",
            x: 0.0,
            y: 0.75,
            isEnabled: false
        ),
        Position(
            id: "M (Left)",
            name: "ML",
            x: 0.0,
            y: -0.75,
            isEnabled: false
        ),
        Position(
            id: "M (Centre)",
            name: "MC",
            x: 0.0,
            y: 0,
            isEnabled: false
        ),
        Position(
            id: "WB (Right)",
            name: "WBR",
            x: -0.3,
            y: 0.75,
            isEnabled: false
        ),
        Position(
            id: "WB (Left)",
            name: "WBL",
            x: -0.3,
            y: -0.75,
            isEnabled: false
        ),
        Position(
            id: "DM (Centre)",
            name: "DMC",
            x: -0.3,
            y: 0,
            isEnabled: false
        ),
        Position(
            id: "D (Right)",
            name: "DR",
            x: -0.65,
            y: 0.75,
            isEnabled: false
        ),
        Position(
            id: "D (Left)",
            name: "DL",
            x: -0.65,
            y: -0.75,
            isEnabled: false
        ),
        Position(
            id: "D (Centre 1)",
            name: "DC",
            x: -0.65,
            y: -0.3,
            isEnabled: false
        ),
        Position(
            id: "D (Centre 2)",
            name: "DC",
            x: -0.65,
            y: 0.3,
            isEnabled: false
        ),
        Position(
            id: "GK",
            name: "GK",
            x: -0.9,
            y: 0,
            isEnabled: false
        ),
    ]
    
    // MARK: - Private Properties
    /// A collection of patterns representing various formations and positions in football.
    private let patterns = [
        "ST",
        "AM (RC)",
        "M/AM (L)",
        "M (L)",
        "D (LC)",
        "WB (L)",
        "M (C)",
        "M/AM (C)",
        "M/AM (RLC)",
        "M (RLC)",
        "D (C)",
        "AM (LC)",
        "DM",
        "AM (C)",
        "D/WB/M/AM (L)",
        "WB/M/AM (L)",
        "GK"
    ]
    
    public init() {
        
    }
    
    // MARK: - Methods
    /// Extracts and formats position strings from a given array of pattern strings.
    /// - Parameter patterns: An array of pattern strings representing football formations and positions.
    /// - Returns: An array of strings with formatted positions.
    public func extractPositions(from patterns: [String]) -> [String] {
        return patterns.compactMap { pattern -> [String]? in
            let components = pattern.components(separatedBy: " ")
            
            // Special handling for 'DM' and 'GK' positions.
            if components[0] == "DM" {
                return ["DMC"]
            }
            if components[0] == "GK" {
                return ["GK"]
            }

            // Ensure the pattern has two components.
            guard components.count == 2 else { return nil }

            let positions = components[0].components(separatedBy: "/")
            let directions = components[1].trimmingCharacters(in: CharacterSet(charactersIn: "()"))
            
            // Generating formatted positions based on given directions.
            var formattedPositions: [String] = []
            for position in positions {
                for direction in directions {
                    let formattedDirection: String
                    switch direction {
                    case "L": formattedDirection = "L"
                    case "C": formattedDirection = "C"
                    case "R": formattedDirection = "R"
                    default: continue
                    }
                    formattedPositions.append("\(position)\(formattedDirection)")
                }
            }
            return formattedPositions.isEmpty ? nil : formattedPositions
        }.reduce([], +)
    }
}
