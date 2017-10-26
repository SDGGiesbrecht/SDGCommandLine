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

internal typealias SwiftTool = _Swift
/// :nodoc: (Shared to Workspace.)
public class _Swift : _ExternalTool {

    // MARK: - Static Properties

    private static let version = Version(4, 0, 0)

    /// :nodoc: (Shared to Workspace.)
    public static let _default: _Swift = SwiftTool(version: SwiftTool.version)
    internal static let `default` = _default

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Swift"
            case .ελληνικάΕλλάδα:
                return "Σουιφτ"
            case .עברית־ישראל:
                return "סוויפט"
            }
        }), webpage: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in // [_Exempt from Code Coverage_]
            switch localization { // [_Exempt from Code Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל: // [_Exempt from Code Coverage_]
                return "swift.org"
            }
        }), command: "swift", version: version, versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage: Workflow

    internal func initializeExecutablePackage(output: inout Command.Output) throws {
        _ = try execute(with: ["package", "init", "\u{2D}\u{2D}type", "executable"], output: &output)
    }

    internal func buildForRelease(output: inout Command.Output) throws {
        _ = try execute(with: ["build", "\u{2D}\u{2D}configuration", "release"], output: &output)
    }

    // MARK: - Usage: Information
}
