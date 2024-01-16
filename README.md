# PitchGraph Opensource

## USAGE

The PitchGraph app (Open-sourced) has three sections:
- Player Search: Type in the name of a player in the search bar to find a player.
- Two-player comparison: Pick two players and compare them visually.
- Last Searched: List of players that users searched.

## Screenshots
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 28](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/c2abd2d6-c474-400f-8931-f07ac61bef53)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 01](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/255c1c6e-0f09-4452-a269-3ef897e4243e)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 04](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/94ec6286-3cc1-4b22-9661-f0ca8a8adeaf)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 39 58](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/ffc7a3b6-fbce-4737-8361-5f84449f23a8)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 24](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/add47428-86f3-4960-952b-b9c3a94a1731)
![Simulator Screenshot - iPhone 15 Pro Max - 2024-01-16 at 01 40 22](https://github.com/jamesryu108/PitchGraphOpenSource/assets/33236626/d63e0e5b-d77e-4fc7-8923-2d0865da9db2)



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
