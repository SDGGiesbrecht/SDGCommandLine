/*
 Initialization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// Initializes SDGCommandLine and SDGCornerstone. Call this before calling anything else from SDGCommandLine.
public func initialize(applicationIdentifier: String, applicationPreferencesClass: Preferences.Type = Preferences.self) {
    SDGCornerstone.initialize(mode: .commandLineTool, applicationIdentifier: applicationIdentifier, applicationPreferencesClass: applicationPreferencesClass)
}
