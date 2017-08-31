/*
 Options.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A set of specified options.
public struct Options {

    // MARK: - Static Properties

    private static let noColourName = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishCanada:
            return "no‐colour"
        case .englishUnitedStates:
            return "no‐color"
        case .deutschDeutschland:
            return "ohne‐farbe"
        case .françaisFrance:
            return "sans‐couleur"
        case .ελληνικάΕλλάδα:
            return "χορίς‐χρώμα"
        case .עברית־ישראל:
            return "ללא־צבע"
        }
    })

    private static let noColourDescription = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishCanada:
            return "Removes colour from the output."
        case .englishUnitedStates:
            return "Removes color from the output."
        case .deutschDeutschland:
            return "Entfernt Farben von der Ausgabe."
        case .françaisFrance:
            return "Supprime les couleurs des sorties."
        case .ελληνικάΕλλάδα:
            return "Αφαιρεί τα χρώματα από την έξοδο."
        case .עברית־ישראל:
            return "מסירה את הצבעים מהפלט."
        }
    })

    internal static let noColour = Option(name: noColourName, description: noColourDescription, type: ArgumentType.boolean)

    // MARK: - Initialization

    internal init() {

    }

    // MARK: - Properties

    private var options: [StrictString: Any] = [:]

    // MARK: - Usage

    internal mutating func add(value: Any, for option: AnyOption) {
        options[option.uniqueKey] = value
    }

    /// Returns the value of the specified option, or `nil` if the option is not defined.
    public func value<T>(for option: Option<T>) -> T? {
        return options[option.key] as? T
    }

    /// Returns `true` if the Boolean flag is active and `false` if it is not.
    public func value(for option: Option<Bool>) -> Bool {
        return (options[option.key] as? Bool) == true
    }
}
