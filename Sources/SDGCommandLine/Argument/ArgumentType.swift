/*
 ArgumentType.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

import SDGSwift

import SDGCommandLineLocalizations

/// A standard argument type provided by SDGCommandLine.
public enum ArgumentType {

    private static func keyOnly(_ key: StrictString) -> UserFacing<StrictString, InterfaceLocalization> {
        return UserFacing({ _ in
            return key
        })
    }
    private static let unused = UserFacing<StrictString, InterfaceLocalization>({ _ in
        unreachable()
    })

    internal static let booleanKey: StrictString = "Boolean"
    /// A Boolean flag.
    public static let boolean: ArgumentTypeDefinition<Bool> = ArgumentTypeDefinition(name: keyOnly(ArgumentType.booleanKey), syntaxDescription: unused, parse: { (_) -> Bool? in
        unreachable()
    })

    private static let stringName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "string"
        }
    })

    private static let stringDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "An arbitrary string."
        }
    })

    /// An argument type that accepts arbitrary strings.
    public static let string: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(name: stringName, syntaxDescription: stringDescription, parse: { (argument: StrictString) -> StrictString? in
        return argument
    })

    private static func enumerationSyntax<L : InputLocalization>(labels: [UserFacing<StrictString, L>]) -> UserFacing<StrictString, InterfaceLocalization> {

        return UserFacing<StrictString, InterfaceLocalization>({ localization in

            let openingQuotationMark: StrictString
            let closingQuotationMark: StrictString
            switch localization {
            case .englishUnitedKingdom:
                openingQuotationMark = "‘"
                closingQuotationMark = "’"
            case .englishUnitedStates, .englishCanada:
                openingQuotationMark = "“"
                closingQuotationMark = "”"
            }

            let comma: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                comma = ", "
            }

            let or: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                or = " or "
            }

            let period: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
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
    public static func enumeration<T, N : InputLocalization, L : InputLocalization>(name: UserFacing<StrictString, N>, cases: [(value: T, label: UserFacing<StrictString, L>)]) -> ArgumentTypeDefinition<T> {

        var syntaxLabels: [UserFacing<StrictString, L>] = []
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

    private static let languagePreferenceName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "language preference"
        }
    })

    private static let languagePreferenceDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom:
            return "A list of IETF language tags or language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: ‘en\u{2D}GB’ or ‘🇬🇧EN’ → British English, ‘cy,en;fr’ → both Welsh and English, otherwise French"
        case .englishUnitedStates:
            return "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}US” or “🇺🇸EN” → American English, “nv,en;es” → both Navajo and English, otherwise Spanish"
        case .englishCanada:
            return "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}CA” or “🇨🇦EN” → Canadian English, “cwd,en;fr” → both Woods Cree and English, otherwise French"
        }
    })

    /// An argument type representing a language preference.
    public static let languagePreference: ArgumentTypeDefinition<LocalizationSetting> = ArgumentTypeDefinition(name: languagePreferenceName, syntaxDescription: languagePreferenceDescription, parse: { (argument: StrictString) -> LocalizationSetting? in

        let groups = argument.components(separatedBy: ConditionalPattern({ $0 ∈ Set<UnicodeScalar>([";", "·"]) })).map({ StrictString($0.contents) })
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

    private static let versionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "version"
        }
    })

    private static let developmentCase = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "development"
        }
    })

    private static let versionDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        let development = ArgumentType.developmentCase.resolved(for: localization)
        switch localization {
        case .englishUnitedKingdom:
            return StrictString("A version number or ‘\(development)’.")
        case .englishUnitedStates, .englishCanada:
            return StrictString("A version number or “\(development)”.")
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
