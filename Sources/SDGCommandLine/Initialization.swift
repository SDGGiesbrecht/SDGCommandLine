/*
 Initialization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

/// Initializes SDGCommandLine and SDGCornerstone. Call this before calling anything else from SDGCommandLine.
///
/// - Parameters:
///     - applicationIdentifier: An application identifier in reverse domain form (tld.Developper.Tool).
///     - version: The semantic version of the tool’s package. This will be displayed by the `version` subcommand. It is recommended to set this to `nil` in between stable releases.
///     - packageURL: The URL of the tool’s Swift package. This is where the `•use‐version` option will look for other versions. The specified repository must be a valid Swift package that builds successfully with nothing more than `swift build`. If the repository is not publicly available or not a Swift package, this parameter should be `nil`, in which case the `•use‐version` option will be unavailable.
///     - applicationPreferencesClass: A subclass of `SDGCornerstone.Preferences` to use for the application preferences instance. Defaults to the `Preferences` class itself.
public func initialize(applicationIdentifier: String, version: Version?, packageURL: URL?) {

    ProcessInfo.applicationIdentifier = applicationIdentifier

    Version.currentToolVersion = version

    if let url = packageURL { // [_Exempt from Test Coverage_]
        Package.current = Package(url: url)
    }
}
