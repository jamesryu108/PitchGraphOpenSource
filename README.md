# PitchGraph Opensource

## USAGE

The PitchGraph app (Open-sourced) has three sections:
- Player Search: Type in the name of a player in the search bar to find a player.
- Two-player comparison: Pick two players and compare them visually.
- Last Searched: List of players that users searched.

## Screenshots
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 24](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/c4f4491b-a06d-4c5d-888c-0ead2cbd6b99)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 39 58](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/db72e2a2-b74b-458a-ab6f-81bd5db591f2)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 04](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/9a32cb44-ee52-4ef4-8294-2f071bbb53ba)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 01](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/5ddb5b64-6284-4602-a767-fb0b66bee934)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 28](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/8413a3d4-d12f-4f48-8749-7867d1d1040f)


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

# Special thanks to
* Maysam Shahsavari for his article on Coordinator, which aided in understanding of the architecture: https://medium.com/@maysam.shahsavari/a-comprehensive-guide-to-coordinator-pattern-in-swift-7e7647ecc525

