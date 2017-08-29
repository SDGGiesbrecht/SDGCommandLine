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

    private static func enumerationSyntax<L : InputLocalization>(labels: [UserFacingText<L, Void>]) -> UserFacingText<ContentLocalization, Void> {

        return UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in

            let openingQuotationMark: StrictString
            let closingQuotationMark: StrictString
            switch localization {
            case .englishUnitedKingdom:
                openingQuotationMark = "‘"
                closingQuotationMark = "’"
            case .englishUnitedStates, .englishCanada:
                openingQuotationMark = "“"
                closingQuotationMark = "”"
            case .deutschDeutschland:
                openingQuotationMark = "„"
                closingQuotationMark = "“"
            case .françaisFrance:
                openingQuotationMark = "« "
                closingQuotationMark = " »"
            case .ελληνικάΕλλάδα:
                openingQuotationMark = "«"
                closingQuotationMark = "»"
            case .עברית־ישראל:
                openingQuotationMark = "”"
                closingQuotationMark = "“"
            }

            let comma: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                comma = ", "
            }

            let or: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                or = " or "
            case .deutschDeutschland:
                or = " oder "
            case .françaisFrance:
                or = " ou "
            case .ελληνικάΕλλάδα:
                or = " ή "
            case .עברית־ישראל:
                or = " או "
            }

            let period: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                period = "."
            }

            let list = labels.map({ openingQuotationMark + $0.resolved() + closingQuotationMark }).sorted()
            var result = StrictString(list.dropLast().joined(separator: comma))
            result.append(contentsOf: or + list.last! + period)
            return result

        })
    }

    /// Creates an enumeration argument type.
    ///
    /// Parameters:
    ///     - name: The name of the option.
    ///     - cases: An array of enumeration options. Specify each option as a tuple containing the option’s name (for the command line) and the option’s value (for within Swift).
    public static func enumeration<T, L : InputLocalization>(name: UserFacingText<L, Void>, cases: [(value: T, label: UserFacingText<L, Void>)]) -> ArgumentTypeDefinition<T> {

        var syntaxLabels: [UserFacingText<L, Void>] = []
        var entries: [StrictString: T] = [:]
        for option in cases {
            syntaxLabels.append(option.label)
            for key in Command.list(names: option.label) {
                entries[key] = option.value
            }
        }

        return ArgumentTypeDefinition(name: name, syntaxDescription: enumerationSyntax(labels: syntaxLabels), parse: { (argument: StrictString) -> T? in
            return entries[argument]
        })
    }
}
