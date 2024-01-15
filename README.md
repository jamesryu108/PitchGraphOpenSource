# PitchGraph Opensource

## USAGE

The PitchGraph app (Open-sourced) has three sections:
- Player Search: Type in the name of a player in the search bar to find a player.
- Two-player comparison: Pick two players and compare them visually.
- Last Searched: List of players that users searched.

## Technologies

* UIKit/SwiftUI
* MVVM-C (MVVM Coordinator pattern)
* Diffable Data source
* Networking is done using URLSession only.
* Used NSCache to avoid fetching the same data many times.
* Localization supported (Korean).
* Zero 3rd-party framework used.

## Architecture

* Dependency injection (To make it modular and testable)
* Singleton
* MVVM-C


## What makes this app worthy?

* MVVM-C architecture that allows for easy scalability, should I want to implement more new features.
* Localization (Korean)
* Get all players from the entire Football Manager 24 database.
* Great UI.
