/*
 PackageRepository.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLineLocalizations

// [_Warning: Temporary_]
import SDGSwift
import SDGSwiftPackageManager

internal typealias PackageRepository = _PackageRepository
/// :nodoc: (Shared to Workspace.)
public struct _PackageRepository {

    // MARK: - Static Properties

    private static let releaseProductsDirectory = ".build/release"

    // MARK: - Initialization

    /// :nodoc: (Shared to Workspace.)
    public init(_alreadyAt location: URL) {
        self._location = location
    }

    // MARK: - Properties

    /// :nodoc: (Shared to Workspace.)
    public let _location: URL
    internal var location: URL {
        return _location
    }

    // MARK: - Actions

    internal func buildForRelease(output: Command.Output) throws -> URL {
        try SDGSwift.PackageRepository(at: location).build(releaseConfiguration: true, staticallyLinkStandardLibrary: true, reportProgress: { output.print($0) })
        return location.appendingPathComponent(PackageRepository.releaseProductsDirectory).resolvingSymlinksInPath()
    }

    // MARK: - Modifications

    internal func commitChanges(description: StrictString, output: Command.Output) throws {
        try FileManager.default.do(in: location) {
            try Git.default.commitChanges(description: description, output: output)
        }
    }

    internal func tag(version: Version, output: Command.Output) throws {
        try FileManager.default.do(in: location) {
            try Git.default.tag(version: version, output: output)
        }
    }
}
