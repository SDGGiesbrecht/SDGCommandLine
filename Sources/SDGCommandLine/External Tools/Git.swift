/*
 Git.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGExternalProcess

// [_Warning: Temporary._]
import SDGSwift

import SDGCommandLineLocalizations

internal typealias Git = _Git
/// :nodoc: (Shared to Workspace.)
public class _Git : _ExternalTool {

    // MARK: - Static Properties

    #if os(Linux)
         private static let version = Version(2, 15, 1)
    #else
         private static let version = Version(2, 15, 1)
    #endif

    /// :nodoc: (Shared to Workspace.)
    public static let _default: _Git = Git(version: Git.version)
    internal static let `default` = _default

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Git"
            }
        }), webpage: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
            switch localization { // [_Exempt from Test Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada /* No localized site: */: // [_Exempt from Test Coverage_]
                return "git\u{2D}scm.com"
            }
        }), command: "git", version: version, versionCheck: ["version"])
    }

    // MARK: - Usage: Workflow

    internal func tag(version: Version, output: Command.Output) throws {
        _ = try execute(with: [
            "tag",
            StrictString(version.string())
            ], output: output)
    }

    // MARK: - Usage: Information

    /// :nodoc: (Shared to Workspace.)
    public func _ignoredFiles(output: Command.Output) throws -> [URL] {

        let ignoredSummary = try executeInCompatibilityMode(with: [
            "status",
            "\u{2D}\u{2D}ignored"
            ], output: output, silently: true)

        let repositoryRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

        var result: [URL] = []
        if let headerRange = ignoredSummary.scalars.firstMatch(for: "Ignored files:".scalars)?.range {
            let remainder = String(ignoredSummary[headerRange.upperBound...])
            for line in remainder.lines.lazy.dropFirst(3).lazy.map({ $0.line }) where ¬line.isEmpty {
                let relativePath = String(StrictString(line.dropFirst()))
                result.append(repositoryRoot.appendingPathComponent(relativePath))
            }
        }
        return result
    }
}
