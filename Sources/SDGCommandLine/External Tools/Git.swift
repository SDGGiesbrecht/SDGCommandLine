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

import SDGCornerstone

internal typealias Git = _Git
/// :nodoc: (Shared to Workspace.)
public class _Git : _ExternalTool {

    // MARK: - Static Properties

    #if os(Linux)
         private static let version = Version(2, 15, 1)
    #else
         private static let version = Version(2, 14, 3)
    #endif

    /// :nodoc: (Shared to Workspace.)
    public static let _default: _Git = Git(version: Git.version)
    internal static let `default` = _default

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Git"
            case .ελληνικάΕλλάδα:
                return "Γκιτ"
            case .עברית־ישראל:
                return "גיט"
            }
        }), webpage: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in // [_Exempt from Test Coverage_]
            switch localization { // [_Exempt from Test Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל: // [_Exempt from Test Coverage_]
                return "git\u{2D}scm.com"
            }
        }), command: "git", version: version, versionCheck: ["version"])
    }

    // MARK: - Usage: Workflow

    internal func initializeRepository(output: inout Command.Output) throws {
        try _initializeRepository(output: &output)
    }
    /// :nodoc: (Shared to Workspace.)
    public func _initializeRepository(output: inout Command.Output) throws {
        _ = try execute(with: ["init"], output: &output)
    }

    internal func shallowlyClone(repository remote: URL, to local: URL, at tagOrBranch: String?, output: inout Command.Output) throws {
        var command = [
            "clone",
            Shell.quote(remote.absoluteString),
            Shell.quote(local.path)
            ]
        if let checkout = tagOrBranch {
            command += [
                "\u{2D}\u{2D}branch", checkout
                ]
        }
        command += [
            "\u{2D}\u{2D}depth", "1",
            "\u{2D}\u{2D}config", "advice.detachedHead=false"
        ]
        _ = try executeInCompatibilityMode(with: command, output: &output)
    }

    /// :nodoc: (Shared to Workspace.)
    public func _differences(excluding excludePatterns: [String], output: inout Command.Output) throws {
        _ = try execute(with: [
            "add",
            ".",
            "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"
            ], output: &output, silently: true)

        _ = try executeInCompatibilityMode(with: [
            "diff",
            "\u{2D}\u{2D}exit\u{2D}code",
            "\u{2D}\u{2D}",
            "."
            ] + excludePatterns.map({ "':(exclude)\($0)'" }), output: &output, autoquote: false)
    }

    internal func commitChanges(description: StrictString, output: inout Command.Output) throws {
        _ = try execute(with: [
            "add",
            "."
            ], output: &output)

        _ = try execute(with: [
            "commit",
            "\u{2D}\u{2D}m", description
            ], output: &output)
    }

    internal func tag(version: Version, output: inout Command.Output) throws {
        _ = try execute(with: [
            "tag",
            StrictString(version.string)
            ], output: &output)
    }

    // MARK: - Usage: Information

    /// :nodoc: (Shared to Workspace.)
    public func _versions(of package: _Package, output: inout Command.Output) throws -> Set<Version> {
        let output = try execute(with: [
            "ls\u{2D}remote",
            "\u{2D}\u{2D}tags",
            StrictString(Shell.quote(package.url.absoluteString))
            ], output: &output, silently: true)

        var versions: Set<Version> = []
        for line in output.lines.map({ $0.line }) {
            if let tagPrefix = line.firstMatch(for: "refs/tags/".scalars) {
                let tag = StrictString(line[tagPrefix.range.upperBound...])
                if let version = Version(String(tag)) {
                    versions.insert(version)
                }
            }
        }
        return versions
    }

    internal func latestCommitIdentifier(in package: Package, output: inout Command.Output) throws -> StrictString {
        return StrictString(try execute(with: [
            "ls\u{2D}remote",
            StrictString(Shell.quote(package.url.absoluteString)),
            "master"
            ], output: &output).truncated(before: "\u{9}".scalars))
    }

    /// :nodoc: (Shared to Workspace.)
    public func _ignoredFiles(output: inout Command.Output) throws -> [URL] {

        let ignoredSummary = try executeInCompatibilityMode(with: [
            "status",
            "\u{2D}\u{2D}ignored"
            ], output: &output, silently: true)

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
