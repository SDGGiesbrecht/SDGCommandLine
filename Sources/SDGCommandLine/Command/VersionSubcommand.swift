/*
 VersionSubcommand.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Command {

    private static let versionName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "version"
        case .deutschDeutschland:
            return "version"
        case .françaisFrance:
            return "version"
        case .ελληνικάΕλλάδα:
            return "έκδοση"
        case .עברית־ישראל:
            return "גירסה"
        }
    })

    private static let versionDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "displays the version in use."
        case .deutschDeutschland:
            return "zeigt die verwendete Version."
        case .françaisFrance:
            return "affiche la version utilisée."
        case .ελληνικάΕλλάδα:
            return "εκθέτει την έκδοση που χρησιμοποιείται."
        case .עברית־ישראל:
            return "מציגה את הגירסה בשימוש."
        }
    })

    internal static let version = Command(name: versionName, description: versionDescription, directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws -> Void in

        if let stable = Version.currentToolVersion {
            print(stable.string, to: &output)
        } else {
            print(UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Not a stable version."
                case .deutschDeutschland:
                    return "Keine beständige Version."
                case .françaisFrance:
                    return "Pas une version stable."
                case .ελληνικάΕλλάδα:
                    return "Δεν είναι σταθερή έκδοση."
                case .עברית־ישראל:
                    return "לא גירסה יציבה."
                }
            }).resolved(), to: &output)
        }
    })
}
