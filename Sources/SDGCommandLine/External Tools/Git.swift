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
}
