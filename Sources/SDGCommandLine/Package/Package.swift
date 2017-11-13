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

import SDGCornerstone

internal typealias Package = _Package
/// :nodoc: (Shared to Workspace.)
public struct _Package {

    // MARK: - Static Properties

    internal static var current: Package?

    private static let versionsCache = FileManager.default.url(in: .cache, at: "Versions")
    private static let developmentCache = versionsCache.appendingPathComponent("Development")

    // MARK: - Initialization

    internal init(url: URL) {
        self.init(_url: url)
    }
    /// :nodoc: (Shared to Workspace.)
    public init(_url: URL) {
        self.url = _url
    }

    // MARK: - Properties

    internal let url: URL

    // MARK: - Usage

    internal func execute(_ version: Build, of executableNames: Set<StrictString>, with arguments: [StrictString], output: inout Command.Output) throws {

        let cache = try cacheDirectory(for: version, output: &output)
        if ¬FileManager.default.fileExists(atPath: cache.path) {

            switch version {
            case .development:
                // Clean up older builds.
                try? FileManager.default.removeItem(at: Package.developmentCache)
            case .version:
                break
            }

            try build(version, to: cache, output: &output)
        }

        for executable in try FileManager.default.contentsOfDirectory(at: cache, includingPropertiesForKeys: nil, options: []) where StrictString(executable.lastPathComponent) ∈ executableNames {

            try Shell.default.run(command: [Shell.quote(executable.path)] + arguments.map({ String($0) }), alternatePrint: { print($0, to: &output) })
            return
        }
    }

    private func cacheDirectory(for version: Build, output: inout Command.Output) throws -> URL {
        switch version {
        case .version(let specific):
            return Package.versionsCache.appendingPathComponent(specific.string)
        case .development:
            return Package.developmentCache.appendingPathComponent(String(try Git.default.latestCommitIdentifier(in: self, output: &output)))
        }
    }

    private func build(_ version: Build, to destination: URL, output: inout Command.Output) throws {
        let temporaryCloneLocation = FileManager.default.url(in: .temporary, at: "Package Clones/" + url.lastPathComponent)
        let temporaryRepository = try PackageRepository(cloning: self, to: temporaryCloneLocation, output: &output)
        defer { try? FileManager.default.removeItem(at: temporaryCloneLocation) }

        switch version {
        case .version(let specific):
            try temporaryRepository.checkout(specific, output: &output)
        case .development:
            break
        }

        let products = try temporaryRepository.buildForRelease(output: &output)

        let intermediateDirectory = FileManager.default.url(in: .temporary, at: UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: intermediateDirectory) }
        for component in try FileManager.default.contentsOfDirectory(at: products, includingPropertiesForKeys: nil, options: []) {
            let filename = component.lastPathComponent

            if filename ≠ "ModuleCache",
                ¬filename.hasSuffix(".build"),
                ¬filename.hasSuffix(".swiftdoc"),
                ¬filename.hasSuffix(".swiftmodule") {

                try FileManager.default.move(component, to: intermediateDirectory.appendingPathComponent(filename))
            }
        }
        try FileManager.default.move(intermediateDirectory, to: destination)
    }
}
