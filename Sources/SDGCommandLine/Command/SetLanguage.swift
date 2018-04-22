/*
 SetLanguage.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLineLocalizations

extension Command {

    private static let setLanguageName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "set‐language"
        }
    })

    private static let setLanguageDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "sets the language preference. (Omit the argument to revert to the system preferences.)"
        }
    })

    internal static let setLanguage = Command(name: setLanguageName, description: setLanguageDescription, directArguments: [ArgumentType.languagePreference], options: [], execution: { (directArguments: DirectArguments, _, _) throws -> Void in

        LocalizationSetting.setApplicationPreferences(to: directArguments.argument(at: 0, as: ArgumentType.languagePreference))
    })
}
