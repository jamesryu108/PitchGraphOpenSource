//
//  PlayerData.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public protocol GoalKeeperConfigurable {
    var selectedOptionIndex: IndexPath? { get }
    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void)
    func checkColorTheme()
    func processData()
    var goalkeeperAttributesForPlayer1: [GoalKeeperAttribute] { get }
    var goalkeeperAttributesForPlayer2: [GoalKeeperAttribute]? { get }
}

public protocol TechnicalConfigurable {
    var selectedOptionIndex: IndexPath? { get }
    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void)
    func checkColorTheme()
    func processData()
    var technicalAttributesForPlayer1: [TechnicalAttribute] { get }
    var technicalAttributesForPlayer2: [TechnicalAttribute]? { get }
}

public protocol PhysicalConfigurable {
    var selectedOptionIndex: IndexPath? { get }
    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void)
    func checkColorTheme()
    func processData()
    var physicalAttributesForPlayer1: [PhysicalAttribute] { get }
    var physicalAttributesForPlayer2: [PhysicalAttribute]? { get }
}

public protocol MentalConfigurable {
    var selectedOptionIndex: IndexPath? { get }
    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void)
    func checkColorTheme()
    func processData()
    var mentalAttributesForPlayer1: [MentalAttribute] { get }
    var mentalAttributesForPlayer2: [MentalAttribute]? { get }
}

public protocol HiddenConfigurable {
    var selectedOptionIndex: IndexPath? { get }
    func subscribeToSelectedOptionIndexChanges(handler: @escaping (IndexPath?) -> Void)
    func checkColorTheme()
    func processData()
    var hiddenAttributesForPlayer1: [HiddenAttribute] { get }
    var hiddenAttributesForPlayer2: [HiddenAttribute]? { get }
}

public protocol PlayerDataProviding {
    func getTechnicalAttributeScore(forAttributeName name: String) -> Int
    func getAllTechnicalAttributes() -> [TechnicalAttribute]
    
    func getPhysicalAttributeScore(forAttributeName name: String) -> Int
    func getAllPhysicalAttributes() -> [PhysicalAttribute]
    
    func getMentalAttributeScore(forAttributeName name: String) -> Int
    func getAllMentalAttributes() -> [MentalAttribute]
    
    func getGoalKeeperAttributeScore(forAttributeName name: String) -> Int
    func getAllGoalKeeperAttributes() -> [GoalKeeperAttribute]
    
    func getHiddenAttributeScore(forAttributeName name: String) -> Int
    func getAllHiddenAttributes() -> [HiddenAttribute]
}

// MARK: - Similar players

public struct SimilarPlayers: Codable {
    public var similarity: Double?
    public var playerData: PlayerData?
    public var comparisonPlayer: PlayerData?
    public init(
        similarity: Double? = nil,
        playerData: PlayerData? = nil,
        comparisonPlayer: PlayerData? = nil
    ) {
        self.similarity = similarity
        self.playerData = playerData
        self.comparisonPlayer = comparisonPlayer
    }
}

// MARK: - PlayerData
public struct PlayerData: Codable, Equatable, Hashable {
    public var playerId, name, age: String?
    public var currentAbility: Int?
    public var potentialAbility, club: String?
    public var minPotentialAbility, maxPotentialAbility: Int?
    public var nationalities, positions: [String]?
    public var askingPrice, contractLength, personality, searchString: String?
    public var reputation: Int?
    public var strongFoot: String?
    public var attributes: Attributes?
    public init(
        playerId: String? = nil,
        name: String? = nil,
        age: String? = nil,
        currentAbility: Int? = nil,
        minPotentialAbility: Int? = nil,
        maxPotentialAbility: Int? = nil,
        potentialAbility: String? = nil,
        club: String? = nil,
        nationalities: [String]? = nil,
        positions: [String]? = nil,
        askingPrice: String? = nil,
        contractLength: String? = nil,
        personality: String? = nil,
        searchString: String? = nil,
        reputation: Int? = nil,
        strongFoot: String? = nil,
        attributes: Attributes? = nil
    ) {
        self.playerId = playerId
        self.name = name
        self.age = age
        self.currentAbility = currentAbility
        self.minPotentialAbility = minPotentialAbility
        self.maxPotentialAbility = maxPotentialAbility
        self.potentialAbility = potentialAbility
        self.club = club
        self.nationalities = nationalities
        self.positions = positions
        self.askingPrice = askingPrice
        self.contractLength = contractLength
        self.personality = personality
        self.searchString = searchString
        self.reputation = reputation
        self.strongFoot = strongFoot
        self.attributes = attributes
    }
    public static func == (lhs: PlayerData, rhs: PlayerData) -> Bool {
        lhs.playerId == rhs.playerId
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(playerId)
    }
    
    static let messiAttributes = Attributes(
        technicals: Technicals(
            crossing: 15,
            corners: 15,
            firstTouch: 19,
            finishing: 17,
            dribbling: 20,
            heading: 10,
            freekicks: 18,
            marking: 4,
            longThrow: 4,
            longshots: 16,
            passing: 19,
            penalties: 17,
            tackling: 7,
            technique: 20
        ),
        mentals: Mentals(
            anticipation: 7,
            aggression: 20,
            bravery: 12,
            composure: 5,
            concentration: 13,
            decisions: 14,
            determination: 20,
            flair: 20,
            leadership: 18,
            offTheBall: 11,
            positioning: 16,
            teamwork: 10,
            vision: 17,
            workrate: 7
        ),
        physicals: Physicals(
            acceleration: 15,
            agility: 15,
            balance: 18,
            jumpingReach: 6,
            naturalFitness: 2,
            pace: 15,
            strength: 9,
            stamina: 12
        ),
        goalkeeping: Goalkeeping(
            aerialReach: 3,
            communication: 3,
            commandOfArea: 1,
            eccentricity: 2,
            handling: 3,
            kicking: 3,
            oneVsOne: 2,
            punching: 1,
            reflexes: 2,
            rushingOut: 1,
            throwing: 4
        ),
        hidden: Hidden(
            adaptability: 17,
            controversy: 5,
            consistency: 16,
            ambition: 18,
            versatility: 12,
            temperament: 14,
            sportsmanship: 15,
            professionalism: 17,
            pressure: 19,
            loyalty: 17,
            injuryProneness: 6,
            importantMatches: 18,
            dirtiness: 9
        )
    )
    
    static public let messiPlayerData = PlayerData(
        playerId: "7458500",
        name: "Lionel Messi",
        age: "35",
        currentAbility: 180,
        potentialAbility: "200",
        club: "PSG",
        nationalities: [
            "ARG",
            "ESP"
        ],
        positions: [
            "AM (RC)",
            "ST (C)"
        ],
        askingPrice: "€76M",
        contractLength: "30/6/2023",
        personality: "Driven",
        searchString: "Lionel Messi",
        reputation: 200,
        // Assuming a high reputation score
        strongFoot: "Left",
        // Assuming based on real-world knowledge
        attributes: messiAttributes
    )
    
    // MARK: - Mock Data for Heung-Min Son
    static let sonAttributes = Attributes(
        technicals: Technicals(
            crossing: 14,
            corners: 14,
            firstTouch: 13,
            finishing: 16,
            dribbling: 15,
            heading: 8,
            freekicks: 13,
            marking: 5,
            longThrow: 6,
            longshots: 16,
            passing: 13,
            penalties: 9,
            tackling: 6,
            technique: 17
        ),
        mentals: Mentals(
            anticipation: 17,
            aggression: 12,
            bravery: 14,
            composure: 7,
            concentration: 17,
            decisions: 13,
            determination: 13,
            flair: 14,
            leadership: 13,
            offTheBall: 11,
            positioning: 14,
            teamwork: 6,
            vision: 15,
            workrate: 8
        ),
        physicals: Physicals(
            acceleration: 16,
            agility: 14,
            balance: 12,
            jumpingReach: 10,
            naturalFitness: 16,
            pace: 16,
            strength: 10,
            stamina: 16
        ),
        goalkeeping: Goalkeeping(
            aerialReach: 2,
            communication: 1,
            commandOfArea: 3,
            eccentricity: 2,
            handling: 2,
            kicking: 2,
            oneVsOne: 1,
            punching: 1,
            reflexes: 2,
            rushingOut: 2,
            throwing: 3
        ),
        hidden: Hidden(
            adaptability: 14,
            controversy: 8,
            consistency: 14,
            ambition: 17,
            versatility: 14,
            temperament: 15,
            sportsmanship: 11,
            professionalism: 18,
            pressure: 14,
            loyalty: 7,
            injuryProneness: 5,
            importantMatches: 14,
            dirtiness: 5
        )
    )
    
    static public let sonPlayerData = PlayerData(
        playerId: "92020288",
        name: "Heung-Min Son",
        age: "31",
        currentAbility: 169,
        minPotentialAbility: 173,
        maxPotentialAbility: 173,
        potentialAbility: "173",
        club: "Tottenham",
        nationalities: ["KOR"],
        positions: [
            "M/AM (L)",
            "ST (C)",
            "M (L)"
        ],
        askingPrice: "£300M",
        contractLength: "30/6/2025",
        personality: "Professional",
        searchString: "Heung-Min Son",
        reputation: 0,
        // Adjust this value as needed
        attributes: sonAttributes
    )
    
    // MARK: - Mock Data for Kim Min-Jae
    static let kimAttributes = Attributes(
        technicals: Technicals(
            crossing: 7,
            corners: 2,
            firstTouch: 12,
            finishing: 7,
            dribbling: 11,
            heading: 16,
            freekicks: 3,
            marking: 16,
            longThrow: 7,
            longshots: 6,
            passing: 14,
            penalties: 6,
            tackling: 16,
            technique: 12
        ),
        mentals: Mentals(
            anticipation: 17,
            aggression: 12,
            bravery: 14,
            composure: 16,
            concentration: 8,
            decisions: 13,
            determination: 8,
            flair: 18,
            leadership: 14,
            offTheBall: 14,
            positioning: 15,
            teamwork: 17,
            vision: 15,
            workrate: 17
        ),
        physicals: Physicals(
            acceleration: 14,
            agility: 12,
            balance: 16,
            jumpingReach: 16,
            naturalFitness: 16,
            pace: 15,
            strength: 17,
            stamina: 15
        ),
        goalkeeping: Goalkeeping(
            aerialReach: 3,
            communication: 1,
            commandOfArea: 3,
            eccentricity: 3,
            handling: 1,
            kicking: 3,
            oneVsOne: 2,
            punching: 2,
            reflexes: 1,
            rushingOut: 2,
            throwing: 1
        ),
        hidden: Hidden(
            adaptability: 17,
            controversy: 8,
            consistency: 17,
            ambition: 18,
            versatility: 8,
            temperament: 10,
            sportsmanship: 12,
            professionalism: 17,
            pressure: 18,
            loyalty: 10,
            injuryProneness: 7,
            importantMatches: 15,
            dirtiness: 8
        )
    )
    
    static public let kimPlayerData = PlayerData(
        playerId: "89063073",
        name: "Kim Min-Jae",
        age: "26",
        currentAbility: 162,
        minPotentialAbility: 165,
        
        maxPotentialAbility: 165,
        potentialAbility: "165",
        club: "FC Bayern",
        nationalities: ["KOR"],
        positions: ["D (C)"],
        askingPrice: "£122M",
        contractLength: "30/6/2028",
        personality: "Driven",
        searchString: "Kim Min-Jae",
        reputation: 0,
        // Adjust this value as needed
        attributes: kimAttributes
    )
    
    // MARK: - Mock Data for Gianluigi Donnarumma
    static let donnaRummaAttributes = Attributes(
        technicals: Technicals(
            crossing: 1,
            corners: 2,
            firstTouch: 7,
            finishing: 1,
            dribbling: 4,
            heading: 7,
            freekicks: 1,
            marking: 2,
            longThrow: 8,
            longshots: 2,
            passing: 7,
            penalties: 6,
            tackling: 7,
            technique: 6
        ),
        mentals: Mentals(
            anticipation: 13,
            aggression: 8,
            bravery: 15,
            composure: 15,
            concentration: 2,
            decisions: 14,
            determination: 6,
            flair: 15,
            leadership: 15,
            offTheBall: 14,
            positioning: 14,
            teamwork: 16,
            vision: 15,
            workrate: 8
        ),
        physicals: Physicals(
            acceleration: 10,
            agility: 16,
            balance: 16,
            jumpingReach: 18,
            naturalFitness: 15,
            pace: 11,
            strength: 16,
            stamina: 15
        ),
        goalkeeping: Goalkeeping(
            aerialReach: 15,
            communication: 14,
            commandOfArea: 14,
            eccentricity: 9,
            handling: 15,
            kicking: 13,
            oneVsOne: 16,
            punching: 14,
            reflexes: 18,
            rushingOut: 11,
            throwing: 12
        ),
        hidden: Hidden(
            adaptability: 7,
            controversy: 5,
            consistency: 16,
            ambition: 16,
            versatility: 1,
            temperament: 14,
            sportsmanship: 15,
            professionalism: 13,
            pressure: 15,
            loyalty: 11,
            injuryProneness: 4,
            importantMatches: 15,
            dirtiness: 4
        )
    )
    
    static public let donnaRummaPlayerData = PlayerData(
        playerId: "43252073",
        name: "Gianluigi Donnarumma",
        age: "24",
        currentAbility: 160,
        minPotentialAbility: 169,
        maxPotentialAbility: 169,
        potentialAbility: "169",
        club: "Paris SG",
        nationalities: ["ITA"],
        positions: ["GK"],
        askingPrice: "£112M",
        contractLength: "30/6/2026",
        personality: "Light-Hearted",
        searchString: "Gianluigi Donnarumma",
        reputation: 0,
        // Adjust this value as needed
        attributes: donnaRummaAttributes
    )
    
    // MARK: - Mock Data for André Onana
    static let onanaAttributes = Attributes(
        technicals: Technicals(
            crossing: 1,
            corners: 1,
            firstTouch: 13,
            finishing: 1,
            dribbling: 3,
            heading: 5,
            freekicks: 4,
            marking: 2,
            longThrow: 3,
            longshots: 1,
            passing: 14,
            penalties: 3,
            tackling: 2,
            technique: 12
        ),
        mentals: Mentals(
            anticipation: 14,
            aggression: 10,
            bravery: 14,
            composure: 14,
            concentration: 1,
            decisions: 14,
            determination: 14,
            flair: 17,
            leadership: 12,
            offTheBall: 12,
            positioning: 16,
            teamwork: 13,
            vision: 13,
            workrate: 9
        ),
        physicals: Physicals(
            acceleration: 12,
            agility: 15,
            balance: 15,
            jumpingReach: 16,
            naturalFitness: 16,
            pace: 11,
            strength: 13,
            stamina: 13
        ),
        goalkeeping: Goalkeeping(
            aerialReach: 15,
            communication: 14,
            commandOfArea: 14,
            eccentricity: 19,
            handling: 15,
            kicking: 15,
            oneVsOne: 13,
            punching: 9,
            reflexes: 17,
            rushingOut: 15,
            throwing: 15
        ),
        hidden: Hidden(
            adaptability: 15,
            controversy: 5,
            consistency: 15,
            ambition: 17,
            versatility: 8,
            temperament: 10,
            sportsmanship: 14,
            professionalism: 11,
            pressure: 16,
            loyalty: 11,
            injuryProneness: 7,
            importantMatches: 15,
            dirtiness: 8
        )
    )
    
    static public let onanaPlayerData = PlayerData(
        playerId: "67201634",
        name: "André Onana",
        age: "27",
        currentAbility: 153,
        minPotentialAbility: 160,
        maxPotentialAbility: 160,
        potentialAbility: "160",
        club: "Man UFC",
        nationalities: ["CMR"],
        positions: ["GK"],
        askingPrice: "£102M",
        contractLength: "30/6/2028",
        personality: "Spirited",
        searchString: "Andre Onana",
        reputation: 0,
        // Adjust this value as needed
        attributes: onanaAttributes
    )
}

// MARK: - Attributes
public struct Attributes: Codable {
    public var technicals: Technicals?
    public var mentals: Mentals?
    public var physicals: Physicals?
    public var goalkeeping: Goalkeeping?
    public var hidden: Hidden?
}

public struct Technicals: Codable {
    public var crossing, corners, firstTouch, finishing: Int
    public var dribbling, heading, freekicks, marking: Int
    public var longThrow, longshots, passing: Int
    public var penalties, tackling, technique: Int
    public func getAllPropertiesWithNames() -> [(
        String,
        Int
    )] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            if let name = child.label, let value = child.value as? Int {
                let separatedName = name.splitBefore(separator: {
                    $0.isUppercase }).joined(separator: " ")
                let formattedName = separatedName.capitalizingFirstLetter()
                return (formattedName, value)
            }
            return nil
        }
    }
}

public struct Mentals: Codable {
    public var anticipation, aggression: Int
    public var bravery, composure, concentration, decisions: Int
    public var determination, flair, leadership, offTheBall: Int
    public var positioning, teamwork, vision, workrate: Int
    public func getAllPropertiesWithNames() -> [(String, Int)] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            if let name = child.label, let value = child.value as? Int {
                let separatedName = name.splitBefore(separator: {
                    $0.isUppercase }).joined(separator: " ")
                let formattedName = separatedName.capitalizingFirstLetter()
                return (formattedName, value)
            }
            return nil
        }
    }
}

public struct Physicals: Codable {
    public var acceleration, agility, balance, jumpingReach: Int
    public var naturalFitness, pace, strength, stamina: Int
    public func getAllPropertiesWithNames() -> [(String, Int)] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            if let name = child.label, let value = child.value as? Int {
                let separatedName = name.splitBefore(separator: { $0.isUppercase }).joined(separator: " ")
                let formattedName = separatedName.capitalizingFirstLetter()
                return (formattedName, value)
            }
            return nil
        }
    }
}

public struct Hidden: Codable {
    public var adaptability, controversy, consistency, ambition: Int
    public var versatility, temperament, sportsmanship, professionalism: Int
    public var pressure, loyalty, injuryProneness, importantMatches: Int
    public var dirtiness: Int
    public func getAllPropertiesWithNames() -> [(
        String,
        Int
    )] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            if let name = child.label, let value = child.value as? Int {
                let separatedName = name.splitBefore(separator: {
                    $0.isUppercase }).joined(separator: " ")
                let formattedName = separatedName.capitalizingFirstLetter()
                return (formattedName, value)
            }
            return nil
        }
    }
}

public struct Goalkeeping: Codable {
    public var aerialReach, communication, commandOfArea, eccentricity: Int
    public var handling, kicking, oneVsOne, punching: Int
    public var reflexes, rushingOut, throwing: Int
    public func getAllPropertiesWithNames() -> [(
        String,
        Int
    )] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            if let name = child.label, let value = child.value as? Int {
                let separatedName = name.splitBefore(separator: {
                    $0.isUppercase }).joined(separator: " ")
                let formattedName = separatedName.capitalizingFirstLetter()
                return (formattedName, value)
            }
            return nil
        }
    }
}

// MARK: - Technical PlayerDataProviding
extension PlayerData: PlayerDataProviding {
    
    public func getTechnicalAttributeScore(forAttributeName name: String) -> Int {
        guard let technicals = self.attributes?.technicals else { return 0 }

        switch name.lowercased() {
        case "crossing": return technicals.crossing
        case "dribbling": return technicals.dribbling
        case "finishing": return technicals.finishing
        case "first touch": return technicals.firstTouch
        case "free kick": return technicals.freekicks
        case "heading": return technicals.heading
        case "long shots": return technicals.longshots
        case "long throws": return technicals.longThrow
        case "marking": return technicals.marking
        case "passing": return technicals.passing
        case "penalty taking": return technicals.penalties
        case "tackling": return technicals.tackling
        case "technique": return technicals.technique
        // Add other cases as needed
        default: return 0
        }
    }
    public func getAllTechnicalAttributes() -> [TechnicalAttribute] {
            guard let technicals = self.attributes?.technicals else { return [] }
            return technicals.getAllPropertiesWithNames().map { (name, score) in
                TechnicalAttribute(name: name, score: score)
            }
        }
}

// MARK: - Physical PlayerDataProviding
extension PlayerData {
    public func getPhysicalAttributeScore(forAttributeName name: String) -> Int {
        guard let physicals = self.attributes?.physicals else { return 0 }

        switch name.lowercased() {
        case "acceleration": return physicals.acceleration
        case "agility": return physicals.agility
        case "balance": return physicals.balance
        case "jumping reach": return physicals.jumpingReach
        case "natural fitness": return physicals.naturalFitness
        case "pace": return physicals.pace
        case "strength": return physicals.strength
        case "stamina": return physicals.stamina
        // Add other cases as needed
        default: return 0
        }
    }

    public func getAllPhysicalAttributes() -> [PhysicalAttribute] {
        guard let physicals = self.attributes?.physicals else { return [] }
        return physicals.getAllPropertiesWithNames().map { (name, score) in
            PhysicalAttribute(name: name, score: score)
        }
    }
}

// MARK: - Get Mental Attribute Score

extension PlayerData {
    public func getMentalAttributeScore(forAttributeName name: String) -> Int {
        guard let mentals = self.attributes?.mentals else { return 0 }

        switch name.lowercased() {
        case "aggression": return mentals.aggression
        case "anticipation": return mentals.anticipation
        case "bravery": return mentals.bravery
        case "composure": return mentals.composure
        case "concentration": return mentals.concentration
        case "decision making": return mentals.decisions
        case "determination": return mentals.determination
        case "flair": return mentals.flair
        case "leadership": return mentals.leadership
        case "off the ball": return mentals.offTheBall
        case "positioning": return mentals.positioning
        case "teamwork": return mentals.teamwork
        case "vision": return mentals.vision
        case "work rate": return mentals.workrate
        default: return 0
        }
    }

    // MARK: - Get All Mental Attributes
    public func getAllMentalAttributes() -> [MentalAttribute] {
        guard let mentals = self.attributes?.mentals else { return [] }
        return mentals.getAllPropertiesWithNames().map { (name, score) in
            MentalAttribute(name: name, score: score)
        }
    }
}

extension PlayerData {
    // MARK: - Get Goalkeeper Attribute Score

    public func getGoalKeeperAttributeScore(forAttributeName name: String) -> Int {
        guard let goalkeepers = self.attributes?.goalkeeping else { return 0 }
        
        switch name.lowercased() {
        case "aerial ability": return goalkeepers.aerialReach
        case "command of area": return goalkeepers.commandOfArea
        case "communication": return goalkeepers.communication
        case "eccentricity": return goalkeepers.eccentricity
        case "handling": return goalkeepers.handling
        case "kicking": return goalkeepers.kicking
        case "one on ones": return goalkeepers.oneVsOne
        case "reflexes": return goalkeepers.reflexes
        case "rushing out": return goalkeepers.rushingOut
        case "punching": return goalkeepers.punching
        case "throwing": return goalkeepers.throwing
        default: return 0
        }
    }

    // MARK: - Get All Goalkeeper Attributes
    public func getAllGoalKeeperAttributes() -> [GoalKeeperAttribute] {
        guard let goalkeepers = self.attributes?.goalkeeping else { return [] }
        return goalkeepers.getAllPropertiesWithNames().map { (name, score) in
            GoalKeeperAttribute(name: name, score: score)
        }
    }

}

extension PlayerData {
    // MARK: - Get Hidden Attribute Score

    public func getHiddenAttributeScore(forAttributeName name: String) -> Int {
        guard let hidden = self.attributes?.hidden else { return 0 }
        
        switch name.lowercased() {
        case "adaptability": return hidden.adaptability
        case "ambition": return hidden.ambition
        case "consistency": return hidden.consistency
        case "controversy": return hidden.controversy
        case "dirtiness": return hidden.dirtiness
        case "important matches": return hidden.importantMatches
        case "injury proneness": return hidden.injuryProneness
        case "loyalty": return hidden.loyalty
        case "pressure": return hidden.pressure
        case "professionalism": return hidden.professionalism
        case "sportsmanship": return hidden.sportsmanship
        case "temperament": return hidden.temperament
        case "versatility": return hidden.versatility
        default: return 0
        }
    }

    // MARK: - Get All Goalkeeper Attributes
    public func getAllHiddenAttributes() -> [HiddenAttribute] {
        guard let hidden = self.attributes?.hidden else { return [] }
        return hidden.getAllPropertiesWithNames().map { (name, score) in
            HiddenAttribute(name: name, score: score)
        }
    }
}
