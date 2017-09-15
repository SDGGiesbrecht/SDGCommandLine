/*
 Swift.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

internal class SwiftTool : ExternalTool {

    // MARK: - Static Properties

    #if os(Linux)
    private static let version = Version(3, 1, 1)
    #else
    private static let version = Version(3, 1, 0)
    #endif

    internal static let `default` = SwiftTool(version: SwiftTool.version)

    // MARK: - Initialization

    private init(version: Version) {
        super.init(name: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Swift"
            case .ελληνικάΕλλάδα:
                return "Σουιφτ"
            case .עברית־ישראל:
                return "סוויפט"
            }
        }), webpage: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                return "swift.org"
            }
        }), command: "swift", version: version, versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage

    internal func initializeExecutablePackage(output: inout Command.Output) throws {
        _ = try execute(with: ["package", "init", "\u{2D}\u{2D}type", "executable"], output: &output)
    }
}
