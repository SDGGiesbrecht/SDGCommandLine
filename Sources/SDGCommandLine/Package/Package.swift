/*
 Package.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

/// A Swift package.
public struct Package {

    // MARK: - Static Properties

    internal static var current: Package?

    // MARK: - Initialization

    /// Creates a package instance.
    public init(url: URL) {
        self.url = url
    }

    // MARK: - Properties

    /// The package URL.
    public let url: URL
}
