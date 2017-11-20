/*
 Xcode.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// :nodoc: (Shared to Workspace.)
public class _Xcode : _ExternalTool {

    /// :nodoc: (Shared to Workspace.)
    public init(_version version: Version) {
        super.init(name: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Xcode"
            case .ελληνικάΕλλάδα:
                return "Έξκοντ"
            case .עברית־ישראל:
                return "אקסקוד"
            }
        }), webpage: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in // [_Exempt from Code Coverage_]
            return "applestore.com/mac/apple/xcode" // Automatically redirected to localized page by Apple.
        }), command: "xcodebuild", version: version, versionCheck: ["\u{2D}version"])
    }
}
