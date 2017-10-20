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
public enum ArgumentType {

    private static func keyOnly(_ key: StrictString) -> UserFacingText<InterfaceLocalization, Void> {
        return UserFacingText({ (_: InterfaceLocalization, _: Void) -> StrictString in
            return key
        })
    }
    private static let unused = UserFacingText({ (_: InterfaceLocalization, _: Void) -> StrictString in
        unreachable()
    })

    internal static let booleanKey: StrictString = "Boolean"
    /// A Boolean flag.
    public static let boolean: ArgumentTypeDefinition<Bool> = ArgumentTypeDefinition(name: keyOnly(ArgumentType.booleanKey), syntaxDescription: unused, parse: { (_) -> Bool? in
        unreachable()
    })

    private static let stringName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
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

    private static let stringDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
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

    private static func enumerationSyntax<L : InputLocalization>(labels: [UserFacingText<L, Void>]) -> UserFacingText<InterfaceLocalization, Void> {

        return UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in

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

    private static let languagePreferenceName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "language preference"
        case .deutschDeutschland:
            return "Spracheinstellung"
        case .françaisFrance:
            return "préférence de langue"
        case .ελληνικάΕλλάδα:
            return "προτίμηση της γλώσσας"
        case .עברית־ישראל:
            return "העדפה של שפה"
        }
    })

    private static let languagePreferenceDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom:
            return "A list of IETF language tags or language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: ‘en\u{2D}GB’ or ‘🇬🇧EN’ → British English, ‘cy,en;fr’ → both Welsh and English, otherwise French"
        case .englishUnitedStates:
            return "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}US” or “🇺🇸EN” → American English, “nv,en;es” → both Navajo and English, otherwise Spanish"
        case .englishCanada:
            return "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}CA” or “🇨🇦EN” → Canadian English, “cwd,en;fr” → both Woods Cree and English, otherwise French"
        case .deutschDeutschland:
            return "Eine Liste von IETF‐Sprachkennungen oder SDGCornerstone Sprachsymbole. Strichpunkte bezeichnen die Ersatzreihenfolge. Kommas bezeichnen die Verwendung mehreren Sprachen. Beispiele: “de\u{2D}DE” oder “🇩🇪DE” → Deutsch (Deutschland), “hab,de;fr” → sowohl Obersorbisch als auch Deutsch, sonst Französisch"
        case .françaisFrance:
            return "Une liste des étiquettes de langue IETF ou des icônes de langue SDGCornerstone. Des point‐virgules indique l’ordre de remplacement. Des virgules indique l’utilisation de plusieurs langues. Examples: « fr\u{2D}FR » or “🇫🇷FR” → français (France), “oc,fr;en” → à la fois occitan et français, sinon anglais"
        case .ελληνικάΕλλάδα:
            return "Ένας κατάλογος του IETF κωδικών γλώσσες ή SDGCornerstone icons γλώσσες. Άνω τελείες σημαίνει την σειρά της αντικατάστασης. Κόμματα σημαίνει ότι πολλαπλές γλώσσες πρέπει να χρησιμοποιούται. Παραδείγματα: «el\u{2D}GR» ή «🇬🇷ΕΛ» → ελληνικά (Ελλάδα), “aat,el·en” → αρβανίτικα και ελληνικά, διαφορετικά αγγλικά"
        case .עברית־ישראל:
            /*א*/ return "רשימה של IETF קודי שפות או SDGCornerstone צלמיות שקות. נקודות ופסיקים מאותתים fallback order. קסיקים מאותתים שימוש של יותר משפה אחת. דוגמאות: ”he\u{2D}IL“ או ”🇮🇱עב“ ← עברית (ישראל), “ydd,he;en” ← יידיש וגם עברית, ואם לא, אנגלית"
        }
    })

    /// An argument type representing a language preference.
    public static let languagePreference: ArgumentTypeDefinition<LocalizationSetting> = ArgumentTypeDefinition(name: languagePreferenceName, syntaxDescription: languagePreferenceDescription, parse: { (argument: StrictString) -> LocalizationSetting? in

        let groups = argument.components(separatedBy: ConditionalPattern(condition: { $0 ∈ Set([";", "·"]) })).map({ StrictString($0.contents) })
        let languages = groups.map({ $0.components(separatedBy: [","]).map({ (component: PatternMatch<StrictString>) -> String in

            let iconOrCode = StrictString(component.contents)
            if let code = InterfaceLocalization.code(for: iconOrCode) {
                return code
            } else {
                return String(iconOrCode)
            }
        }) })
        return LocalizationSetting(orderOfPrecedence: languages)
    })

    private static let versionName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "version"
        case .deutschDeutschland:
            return "Version"
        case .françaisFrance:
            return "version"
        case .ελληνικάΕλλάδα:
            return "έκδοση"
        case .עברית־ישראל:
            return "גירסה"
        }
    })

    private static let developmentCase = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "development"
        case .deutschDeutschland:
            return "entwicklung"
        case .françaisFrance:
            return "développement"
        case .ελληνικάΕλλάδα:
            return "ανάπτυξη"
        case .עברית־ישראל:
            return "פיתוח"
        }
    })

    private static let versionDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        let development = ArgumentType.developmentCase.resolved(for: localization)
        switch localization {
        case .englishUnitedKingdom:
            return StrictString("A version number or ‘\(development)’.")
        case .englishUnitedStates, .englishCanada:
            return StrictString("A version number or “\(development)”.")
        case .deutschDeutschland:
            return StrictString("Eine Versionsnummer oder „\(development)“.")
        case .françaisFrance:
            return StrictString("Un numéro de version ou « \(development) ».")
        case .ελληνικάΕλλάδα:
            return StrictString("Ένα αριθμός έκδοσης ή «\(development)».")
        case .עברית־ישראל:
            return StrictString("גירסת מספר או ”\(development)“.")
        }
    })

    internal static let version: ArgumentTypeDefinition<Build> = ArgumentTypeDefinition(name: versionName, syntaxDescription: versionDescription, parse: { (argument: StrictString) -> Build? in

        if let version = Version(String(argument)) {
            return Build.version(version)
        } else {
            for localization in InterfaceLocalization.cases {
                if argument == ArgumentType.developmentCase.resolved(for: localization) {
                    return Build.development
                }
            }
            return nil
        }
    })
}
