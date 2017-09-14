/*
 Git.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

internal class Git : ExternalTool {

    // MARK: - Static Properties

    #if Linux
         // [_Warning: This should be looked up._]
         private static let version = Version(0, 0, 0)
    #else
         private static let version = Version(2, 11, 0)
    #endif

    internal static let `default` = Git(version: Git.version)

    // MARK: - Initialization

    private init(version: Version) {
        super.init(name: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Git"
            case .ελληνικάΕλλάδα:
                return "Γκιτ"
            case .עברית־ישראל:
                return "גיט"
            }
        }), webpage: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                return "git\u{2D}scm.com"
            }
        }), command: "git", version: version, versionCheck: ["version"])
    }

    // MARK: - Usage

    internal func initializeRepository() throws {
        _ = try execute(with: ["init"])
    }

    internal func commit(message: StrictString) throws {
        _ = try execute(with: ["add", "."])
        _ = try execute(with: ["commit", "\u{2D}\u{2D}m", message])
    }

    internal func tag(version: Version) throws {
        _ = try execute(with: ["tag", StrictString(version.string)])
    }
}
