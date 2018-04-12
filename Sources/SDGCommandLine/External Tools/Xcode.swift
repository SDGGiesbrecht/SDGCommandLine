/*
 Xcode.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !os(Linux)
    // MARK: - #if !os(Linux)

    /// :nodoc: (Shared to Workspace.)
    public class _Xcode : _ExternalTool {

        /// :nodoc: (Shared to Workspace.)
        public init(_version version: Version) {
            super.init(name: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Xcode"
                }
            }), webpage: UserFacingText({ (_: InterfaceLocalization) -> StrictString in // [_Exempt from Test Coverage_]
                return "applestore.com/mac/apple/xcode" // Automatically redirected to localized page by Apple.
            }), command: "xcodebuild", version: version, versionCheck: ["\u{2D}version"])
        }
    }

#endif
