//
//  UserDefaultsManager.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import Foundation

/// A singleton class responsible for managing UserDefaults storage in the application.
final class UserDefaultsManager: UserDefaultsManaging {
    
    // Custom error type for UserDefaults operations
    enum UserDefaultsError: Error {
        case decodingFailed
        case encodingFailed
        case dataNotFound
    }
    
    /// Shared instance for singleton access.
    static let shared = UserDefaultsManager()
    
    /// UserDefaults instance, can be injected for testing.
    let defaults: UserDefaults
    
    /// Private initializer to prevent instantiation from outside.
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    /// Marks the application as launched in UserDefaults.
    func markAppAsLaunched() {
        defaults.set(true, forKey: UserDefaultsKey.hasLaunchedBefore.rawValue)
    }
    
    /// Checks whether the application has been launched before.
    /// - Returns: Boolean indicating if the app has been launched before.
    func hasAppLaunchedBefore() -> Bool {
        defaults.bool(forKey: UserDefaultsKey.hasLaunchedBefore.rawValue)
    }
    
    /// Registers default search parameters in UserDefaults.
    func registerDefaultSearchParameters() {
        let defaultValues: [String: Any] = [
            UserDefaultsKey.ageRangeMin.rawValue: 0,
            UserDefaultsKey.ageRangeMax.rawValue: 60,
            UserDefaultsKey.abilityRangeMin.rawValue: 0,
            UserDefaultsKey.abilityRangeMax.rawValue: 200,
            UserDefaultsKey.potentialRangeMin.rawValue: 0,
            UserDefaultsKey.potentialRangeMax.rawValue: 200,
            UserDefaultsKey.selectedSortOption.rawValue: SortOption.nothing.rawValue,
            UserDefaultsKey.selectedOptionIndex.rawValue: 0
        ]
        
        defaults.register(defaults: defaultValues)
    }
        
    /// Asynchronously saves a Codable object to UserDefaults.
    /// - Parameters:
    ///   - data: The Codable object to be saved.
    ///   - key: The type-safe key under which the data should be saved.
    /// - Throws: An error if the encoding process fails.
    func save<T: Codable>(_ data: T, for key: UserDefaultsKey) async throws {
        let encodedData = try JSONEncoder().encode(data)
        defaults.set(encodedData, forKey: key.rawValue)
    }
    
    /// Saves player data to UserDefaults.
    /// - Parameters:
    ///   - data: The player data to be saved.
    ///   - key: The key under which the data should be saved.
    /// - Throws: An error if the encoding process fails.
    func savePlayerData(data: PlayerData, key: UserDefaultsKey) async throws {
        do {
            let encodedData = try JSONEncoder().encode(data)
            defaults.set(encodedData, forKey: key.rawValue)
        } catch {
            throw UserDefaultsError.encodingFailed
        }
    }
    
    /// Asynchronously loads a Codable object from UserDefaults.
    /// - Parameters:
    ///   - key: The type-safe key from which to load the data.
    ///   - type: The type of Codable object to be loaded.
    /// - Returns: The loaded Codable object.
    /// - Throws: An error if the decoding process fails.
    func load<T: Codable>(for key: UserDefaultsKey, as type: T.Type) async throws -> T {
        guard let savedData = defaults.data(forKey: key.rawValue) else {
            throw UserDefaultsError.dataNotFound
        }
        return try JSONDecoder().decode(type, from: savedData)
    }
    
    /// Loads simple data types from UserDefaults.
    /// - Parameter key: The key from which to load the data.
    /// - Returns: An optional object if present.
    /// - Throws: An error if any loading process fails.
    func load(key: String) throws -> Any? {
        return defaults.object(forKey: key)
    }
    
    /// Deletes data associated with a specific key from UserDefaults.
    /// - Parameter key: The key for which data should be deleted.
    func delete(key: UserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    /// Saves search parameters to UserDefaults.
    /// - Parameter parameters: The `SearchParameter` object to be saved.
    func saveSearchParameters(_ parameters: SearchParameter) {
        defaults.set(parameters.ageRange.lowerBound, forKey: UserDefaultsKey.ageRangeMin.rawValue)
        defaults.set(parameters.ageRange.upperBound, forKey: UserDefaultsKey.ageRangeMax.rawValue)
        defaults.set(parameters.abilityRange.lowerBound, forKey: UserDefaultsKey.abilityRangeMin.rawValue)
        defaults.set(parameters.abilityRange.upperBound, forKey: UserDefaultsKey.abilityRangeMax.rawValue)
        defaults.set(parameters.potentialRange.lowerBound, forKey: UserDefaultsKey.potentialRangeMin.rawValue)
        defaults.set(parameters.potentialRange.upperBound, forKey: UserDefaultsKey.potentialRangeMax.rawValue)
        defaults.set(parameters.sortOption.rawValue, forKey: UserDefaultsKey.selectedSortOption.rawValue)
    }
    
    /// Loads search parameters from UserDefaults.
    /// - Returns: A `SearchParameter` object containing the loaded values.
    func loadSearchParameters() -> SearchParameter {
        let ageRange = defaults.integer(forKey: UserDefaultsKey.ageRangeMin.rawValue)...defaults.integer(forKey: UserDefaultsKey.ageRangeMax.rawValue)
        let abilityRange = defaults.integer(forKey: UserDefaultsKey.abilityRangeMin.rawValue)...defaults.integer(forKey: UserDefaultsKey.abilityRangeMax.rawValue)
        let potentialRange = defaults.integer(forKey: UserDefaultsKey.potentialRangeMin.rawValue)...defaults.integer(forKey: UserDefaultsKey.potentialRangeMax.rawValue)
        let sortOptionString = defaults.string(forKey: UserDefaultsKey.selectedSortOption.rawValue) ?? SortOption.nothing.rawValue
        let sortOption = SortOption(rawValue: sortOptionString) ?? .nothing
        
        return SearchParameter(
            ageRange: ageRange,
            abilityRange: abilityRange,
            potentialRange: potentialRange,
            sortOption: sortOption
        )
    }
    /// Mark onboarding as played by setting its value as `true` so that this value can be evaluated later and when it is evaluated as `true` it will signal the app to not play the onboarding
    func markOnboardingAsPlayed() {
        defaults.set(true, forKey: UserDefaultsKey.onboardingPlayed.rawValue)
    }
    
    /// Saves the selected option index to UserDefaults using a specified key.
    /// - Parameters:
    ///   - indexPath: The `IndexPath` representing the selected option.
    ///   - key: The `UserDefaultsKey` under which the index should be saved.
    /// This method saves the row of the `IndexPath` to UserDefaults under the provided key.
    func saveSelectedOptionIndex(_ indexPath: IndexPath, for key: UserDefaultsKey) {
        Task {
            do {
                try await save(indexPath, for: key)
                print("saved successfully...")
            } catch {
                debugPrint("save: \(error.localizedDescription)")
            }
        }
    }
    
    /// Loads the selected option index from UserDefaults using a specified key.
    /// - Parameter key: The `UserDefaultsKey` from which to load the index.
    /// - Returns: An `IndexPath` representing the previously selected option, or `nil` if no selection was previously saved.
    /// This method retrieves the saved row from UserDefaults using the provided key.
    /// If a row value is found, it constructs an `IndexPath` using this row and section 0.
    /// Returns `nil` if no previously selected option is found in UserDefaults for the given key.
    func loadSelectedOptionIndex(for key: UserDefaultsKey) async -> IndexPath? {
            do {
                let test = try await load(for: .selectedOptionIndex, as: IndexPath.self)
                print("test: \(test)")
                return test
            } catch {
                debugPrint("debug \(error.localizedDescription)")
            }

        return nil
    }
}

extension UserDefaultsManager {
    func loadSelectedOptionIndexSynchronously(for key: UserDefaultsKey) -> IndexPath? {
        if let data = defaults.data(forKey: key.rawValue) {
            do {
                let indexPath = try JSONDecoder().decode(IndexPath.self, from: data)
                print("did it load?")
                return indexPath
            } catch {
                debugPrint("Decoding error: \(error)")
            }
        }
        return nil
    }
}
