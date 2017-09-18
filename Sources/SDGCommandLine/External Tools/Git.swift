/*
 Git.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

internal class Git : ExternalTool {

    // MARK: - Static Properties

    #if os(Linux)
         private static let version = Version(2, 14, 1)
    #else
         private static let version = Version(2, 11, 0)
    #endif

    internal static let `default` = Git(version: Git.version)

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Git"
            case .ελληνικάΕλλάδα:
                return "Γκιτ"
            case .עברית־ישראל:
                return "גיט"
            }
        }), webpage: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in // [_Exempt from Code Coverage_]
            switch localization { // [_Exempt from Code Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל: // [_Exempt from Code Coverage_]
                return "git\u{2D}scm.com"
            }
        }), command: "git", version: version, versionCheck: ["version"])
    }

    // MARK: - Usage

    internal func initializeRepository(output: inout Command.Output) throws {
        _ = try execute(with: ["init"], output: &output)
    }

    internal func clone(repository remote: URL, to local: URL, output: inout Command.Output) throws {
        _ = try execute(with: ["clone", StrictString(Shell.quote(remote.absoluteString)), StrictString(Shell.quote(local.path))], output: &output)
    }

    internal func checkout(_ version: Version, output: inout Command.Output) throws {
        _ = try execute(with: ["checkout", StrictString(version.string)], output: &output)
    }

    internal func commitChanges(description: StrictString, output: inout Command.Output) throws {
        _ = try execute(with: ["add", "."], output: &output)
        _ = try execute(with: ["commit", "\u{2D}\u{2D}m", description], output: &output)
    }

    internal func tag(version: Version, output: inout Command.Output) throws {
        _ = try execute(with: ["tag", StrictString(version.string)], output: &output)
    }

    internal func latestCommitIdentifier(in package: Package, output: inout Command.Output) throws -> StrictString {
        return StrictString(try execute(with: ["ls\u{2D}remote", StrictString(Shell.quote(package.url.absoluteString)), "master"], output: &output).truncated(before: "\u{9}".scalars))
    }
}
