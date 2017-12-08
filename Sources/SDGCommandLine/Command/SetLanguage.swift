/*
 SetLanguage.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Command {

    private static let setLanguageName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "set‐language"
        case .deutschDeutschland:
            return "sprache‐einstellen"
        case .françaisFrance:
            return "définir‐langue"
        case .ελληνικάΕλλάδα:
            return "οριζμός‐γλώσσας"
        case .עברית־ישראל:
            return "הגדיר־את־שפה"
        }
    })

    private static let setLanguageDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "sets the language preference. (Omit the argument to revert to the system preferences.)"
        case .deutschDeutschland:
            return "stellt die Spracheinstellung ein. (Das Argument auslassen, um auf den Systemeinstellungen zurückzusetzen.)"
        case .françaisFrance:
            return "définit la préférence de langue. (Omettre l’argument pour revenir à les préférences système.)"
        case .ελληνικάΕλλάδα:
            return "ορίζει την προτίμηση της γλώσσας. (Η παράλειψη του ορίσματος επαναφέρει στις προτιμήσεις συστήμαρος.)"
        case .עברית־ישראל:
            return "מגדירה את ההעדפה של שפה. (ההשמצה של ארגומנט חוזרה להעדפות המערכת.)"
        }
    })

    internal static let setLanguage = Command(name: setLanguageName, description: setLanguageDescription, directArguments: [ArgumentType.languagePreference], options: [], execution: { (directArguments: DirectArguments, _, _) throws -> Void in

        LocalizationSetting.setApplicationPreferences(to: directArguments.argument(at: 0, as: ArgumentType.languagePreference))
    })
}
