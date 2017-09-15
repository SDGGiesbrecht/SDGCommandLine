/*
 PackageRepository.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

internal struct PackageRepository {

    // MARK: - Initialization

    internal init(initializingAt location: URL, output: inout Command.Output) throws {
        self.location = location
        self.package = Package(url: location)

        try FileManager.default.do(in: location) {
            try SwiftTool.default.initializeExecutablePackage(output: &output)
            try Git.default.initializeRepository(output: &output)
        }
        try commitChanges(description: "Initialized.", output: &output)
    }

    // MARK: - Properties

    internal let package: Package
    private let location: URL

    // MARK: - Information

    internal func url(for relativePath: String) -> URL {
        return location.appendingPathComponent(relativePath)
    }

    // MARK: - Modifications

    internal func commitChanges(description: StrictString, output: inout Command.Output) throws {
        try FileManager.default.do(in: location) {
            try Git.default.commitChanges(description: description, output: &output)
        }
    }

    internal func tag(version: Version, output: inout Command.Output) throws {
        try FileManager.default.do(in: location) {
            try Git.default.tag(version: version, output: &output)
        }
    }
}
