//
//  UserDefaultsKey.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

public enum UserDefaultsKey: String {
    // Define the keys here
    case playerData1
    case playerData2
    case hasLaunchedBefore
    case selectedSortOption
    case ageRangeMin
    case ageRangeMax
    case abilityRangeMin
    case abilityRangeMax
    case potentialRangeMin
    case potentialRangeMax
    case onboardingPlayed
    case selectedOptionIndex
}

public protocol UserDefaultsManaging {
    func markAppAsLaunched()
    func hasAppLaunchedBefore() -> Bool
    func delete(key: UserDefaultsKey)
    func saveSearchParameters(_ parameters: SearchParameter)
    func loadSearchParameters() -> SearchParameter
    func savePlayerData(data: PlayerData, key: UserDefaultsKey) async throws
    func save<T: Codable>(_ data: T, for key: UserDefaultsKey) async throws
    func load<T: Codable>(for key: UserDefaultsKey, as type: T.Type) async throws -> T
    func load(key: String) throws -> Any?
    func registerDefaultSearchParameters()
    func markOnboardingAsPlayed()
    func saveSelectedOptionIndex(_ indexPath: IndexPath, for key: UserDefaultsKey)
    func loadSelectedOptionIndex(for key: UserDefaultsKey) async -> IndexPath?
    func loadSelectedOptionIndexSynchronously(for key: UserDefaultsKey) -> IndexPath?
}
