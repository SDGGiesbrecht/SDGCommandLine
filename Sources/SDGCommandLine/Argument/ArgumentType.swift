/*
 ArgumentType.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A standard argument type provided by SDGCommandLine.
public struct ArgumentType {

    private static func keyOnly(_ key: StrictString) -> UserFacingText<ContentLocalization, Void> {
        return UserFacingText({ (_: ContentLocalization, _: Void) -> StrictString in
            return key
        })
    }
    private static let unused = UserFacingText({ (_: ContentLocalization, _: Void) -> StrictString in
        unreachable()
    })

    internal static let booleanKey: StrictString = "Boolean"
    /// A Boolean flag.
    public static let boolean: ArgumentTypeDefinition<Bool> = ArgumentTypeDefinition(name: keyOnly(ArgumentType.booleanKey), syntaxDescription: unused, parse: { (_) -> Bool? in
        unreachable()
    })

    private static let stringName = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "string"
        case .deutschDeutschland:
            return "Zeichenkette"
        case .françaisFrance:
            return "chaîne de caractères"
        case .ελληνικάΕλλάδα:
            return "συμβολοσειρά"
        case .עברית־ישראל:
            return "מחרוזת"
        }
    })

    private static let stringDescription = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "An arbitrary string."
        case .deutschDeutschland:
            return "Eine beliebige Zeichenkette."
        case .françaisFrance:
            return "Une chaîne de caractères quelconque."
        case .ελληνικάΕλλάδα:
            return "Μία αυθαίρετη συμβολοσειρά."
        case .עברית־ישראל:
            return "מחרוזת רצוני."
        }
    })

    /// An argument type that accepts arbitrary strings.
    public static let string: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(name: stringName, syntaxDescription: stringDescription, parse: { (argument: StrictString) -> StrictString? in
        return argument
    })
}
