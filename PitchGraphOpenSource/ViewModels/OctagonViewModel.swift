//
//  OctagonViewModel.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// `OctagonViewModel` is an `ObservableObject` class responsible for managing the data and logic required to create and display an octagon graph for one or two players. It calculates different player attributes and organizes them into octagon data points.
public final class OctagonViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published public var firstPlayerOctagonData: [OctagonData] = []
    @Published public var secondPlayerOctagonData: [OctagonData] = []
    @Published public var progress: CGFloat = 0.0
    @Published public var count = 0 // A state variable to track the count

    // MARK: - Timer Property
    /// A timer that fires every 0.1 second on the main run loop in the common mode. Used for updating any time-based data.
    public let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // MARK: - Initializers
    
    public init() {
        
    }
    
    // MARK: - Octagon Calculation Methods
    /// Calculates the position of a point on the octagon based on the index, radius, and center point.
    /// - Parameters:
    ///   - index: The index of the point around the octagon.
    ///   - radius: The radius of the octagon.
    ///   - center: The center point of the octagon.
    /// - Returns: The calculated point on the octagon.
    public func pointOnOctagon(for index: Int, radius: CGFloat, center: CGPoint) -> CGPoint {
        let sides = 8
        let angle = 2 * .pi / CGFloat(sides)
        let x = center.x + radius * cos(CGFloat(index) * angle)
        let y = center.y + radius * sin(CGFloat(index) * angle)
        return CGPoint(x: x, y: y)
    }

    /// Creates octagon data for up to two players.
    /// - Parameters:
    ///   - firstPlayerData: Data for the first player.
    ///   - secondPlayerData: Optional data for the second player.
    public func createOctagonData(firstPlayerData: PlayerData, secondPlayerData: PlayerData? = nil) {
        firstPlayerOctagonData = calculateOctagonData(playerData: firstPlayerData)
        if let secondPlayerData = secondPlayerData {
            secondPlayerOctagonData = calculateOctagonData(playerData: secondPlayerData)
        } else {
            secondPlayerOctagonData = []
        }
    }

    /// Calculates the octagon data points for a player.
    /// - Parameter playerData: The data of the player.
    /// - Returns: An array of `OctagonData` representing various attributes of the player.
    public func calculateOctagonData(playerData: PlayerData) -> [OctagonData] {
        return [
            calculateDefending(playerData: playerData),
            calculatePhysical(playerData: playerData),
            calculateAttacking(playerData: playerData),
            calculateAerial(playerData: playerData),
            calculateTechnical(playerData: playerData),
            calculateMental(playerData: playerData),
            calculateSpeed(playerData: playerData),
            calculateVision(playerData: playerData)
        ]
    }

    // MARK: - Private Attribute Calculation Methods

    /// Calculates the defending attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's defending ability.
    private func calculateDefending(playerData: PlayerData) -> OctagonData {
        // Calculate average defending attributes.
        let positioning = playerData.attributes?.mentals?.positioning ?? 0
        let tackling = playerData.attributes?.technicals?.tackling ?? 0
        let marking = playerData.attributes?.technicals?.marking ?? 0
        let defending = Double(positioning + tackling + marking) / 3
        
        // Return as OctagonData.
        return OctagonData(category: "Defending".localized, rating: defending, color: .systemBlue)
    }

    /// Calculates the physical attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's physical ability.
    private func calculatePhysical(playerData: PlayerData) -> OctagonData {
        // Calculate average physical attributes.
        let agility = playerData.attributes?.physicals?.agility ?? 0
        let balance = playerData.attributes?.physicals?.balance ?? 0
        let stamina = playerData.attributes?.physicals?.stamina ?? 0
        let strength = playerData.attributes?.physicals?.strength ?? 0
        let physical = Double(agility + balance + stamina + strength) / 4

        // Return as OctagonData.
        return OctagonData(category: "Physical".localized, rating: physical, color: .systemBlue)
    }

    /// Calculates the attacking attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's attacking ability.
    private func calculateAttacking(playerData: PlayerData) -> OctagonData {
        // Calculate average attacking attributes.
        let finishing = playerData.attributes?.technicals?.finishing ?? 0
        let composure = playerData.attributes?.mentals?.composure ?? 0
        let offTheBall = playerData.attributes?.mentals?.offTheBall ?? 0
        let attacking = Double(finishing + composure + offTheBall) / 3

        // Return as OctagonData.
        return OctagonData(category: "Attacking".localized, rating: attacking, color: .systemBlue)
    }

    /// Calculates the aerial attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's aerial ability.
    private func calculateAerial(playerData: PlayerData) -> OctagonData {
        // Calculate average aerial attributes.
        let heading = playerData.attributes?.technicals?.heading ?? 0
        let jumping = playerData.attributes?.physicals?.jumpingReach ?? 0
        let aerial = Double(heading + jumping) / 2

        // Return as OctagonData.
        return OctagonData(category: "Aerial".localized, rating: aerial, color: .systemBlue)
    }

    /// Calculates the technical attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's technical ability.
    private func calculateTechnical(playerData: PlayerData) -> OctagonData {
        // Calculate average technical attributes.
        let dribbling = playerData.attributes?.technicals?.dribbling ?? 0
        let firstTouch = playerData.attributes?.technicals?.firstTouch ?? 0
        let technique = playerData.attributes?.technicals?.technique ?? 0
        let technical = Double(dribbling + firstTouch + technique) / 3

        // Return as OctagonData.
        return OctagonData(category: "Technical".localized, rating: technical, color: .systemBlue)
    }

    /// Calculates the mental attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's mental ability.
    private func calculateMental(playerData: PlayerData) -> OctagonData {
        // Calculate average mental attributes.
        let anticipation = playerData.attributes?.mentals?.anticipation ?? 0
        let bravery = playerData.attributes?.mentals?.bravery ?? 0
        let concentration = playerData.attributes?.mentals?.concentration ?? 0
        let decisions = playerData.attributes?.mentals?.decisions ?? 0
        let determination = playerData.attributes?.mentals?.determination ?? 0
        let teamWork = playerData.attributes?.mentals?.teamwork ?? 0
        let mental = Double(anticipation + bravery + concentration + decisions + determination + teamWork) / 6

        // Return as OctagonData.
        return OctagonData(category: "Mental".localized, rating: mental, color: .systemBlue)
    }

    /// Calculates the speed attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's speed.
    private func calculateSpeed(playerData: PlayerData) -> OctagonData {
        // Calculate average speed attributes.
        let acceleration = playerData.attributes?.physicals?.acceleration ?? 0
        let pace = playerData.attributes?.physicals?.pace ?? 0
        let speed = Double(acceleration + pace) / 2

        // Return as OctagonData.
        return OctagonData(category: "Speed".localized, rating: speed, color: .systemBlue)
    }

    /// Calculates the vision attribute for a player.
    /// - Parameter playerData: Data of the player.
    /// - Returns: `OctagonData` representing the player's vision.
    private func calculateVision(playerData: PlayerData) -> OctagonData {
        // Calculate average vision attributes.
        let passing = playerData.attributes?.technicals?.passing ?? 0
        let flair = playerData.attributes?.mentals?.flair ?? 0
        let vision = playerData.attributes?.mentals?.vision ?? 0
        let visioning = Double(passing + flair + vision) / 3

        // Return as OctagonData.
        return OctagonData(category: "Vision".localized, rating: visioning, color: .systemBlue)
    }

}
