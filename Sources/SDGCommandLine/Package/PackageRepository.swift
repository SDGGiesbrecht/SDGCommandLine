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

internal typealias PackageRepository = _PackageRepository
/// :nodoc: (Shared with Workspace.)
public struct _PackageRepository {

    // MARK: - Static Properties

    private static let releaseProductsDirectory = ".build/release"

    // MARK: - Initialization

    internal init(initializingAt location: URL, output: inout Command.Output) throws {
        self.location = location

        try FileManager.default.do(in: location) {
            try SwiftTool.default.initializeExecutablePackage(output: &output)
            try Git.default.initializeRepository(output: &output)
        }
        try commitChanges(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom:
                return "Initialised."
            case .englishUnitedStates, .englishCanada:
                return "Initialized."
            case .deutschDeutschland:
                return "Initialisiert."
            case .françaisFrance:
                return "Initialisé."
            case .ελληνικάΕλλάδα:
                return "Αρχικοποίησα."
            case .עברית־ישראל:
                return "אתחלתי."
            }
        }).resolved(), output: &output)
    }

    internal init(cloning package: Package, to location: URL, output: inout Command.Output) throws {
        self.location = location

        try Git.default.clone(repository: package.url, to: location, output: &output)
    }

    internal init(alreadyAt location: URL) {
        self.init(_alreadyAt: location)
    }
    /// :nodoc: (Shared with Workspace.)
    public init(_alreadyAt location: URL) {
        self.location = location
    }

    // MARK: - Properties

    private let location: URL
    /// :nodoc: (Shared with Workspace.)
    public var _location: URL {
        return location
    }

    // MARK: - Information

    internal func url(for relativePath: String) -> URL {
        return _url(for: relativePath)
    }
    /// :nodoc: (Shared with Workspace.)
    public func _url(for relativePath: String) -> URL {
        return location.appendingPathComponent(relativePath)
    }

    // MARK: - Actions

    internal func buildForRelease(output: inout Command.Output) throws -> URL {
        try FileManager.default.do(in: location) {
            try SwiftTool.default.buildForRelease(output: &output)
        }
        return location.appendingPathComponent(PackageRepository.releaseProductsDirectory).resolvingSymlinksInPath()
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

    internal func checkout(_ version: Version, output: inout Command.Output) throws {
        try FileManager.default.do(in: location) {
            try Git.default.checkout(version, output: &output)
        }
    }
}
