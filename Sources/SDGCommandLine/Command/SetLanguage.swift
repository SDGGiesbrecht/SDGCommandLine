/*
 SetLanguage.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLineLocalizations

extension Command {

  private static let setLanguageName = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "set‐language"
      case .deutschDeutschland:
        return "sprache‐einstellen"
      }
    })

  private static let setLanguageDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return
          "sets the language preference. (Omit the argument to revert to the system preferences.)"
      case .deutschDeutschland:
        return
          "stellt die Spracheinstellung ein. (Das Argument weglassen, um an die Systemeinstellungen zurückzufallen.)"
      }
    })

  // #workaround(workspace version 0.32.1, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    internal static let setLanguage = Command(
      name: setLanguageName,
      description: setLanguageDescription,
      directArguments: [ArgumentType.languagePreference],
      options: [],
      execution: { (directArguments: DirectArguments, _, _) throws -> Void in

        LocalizationSetting.setApplicationPreferences(
          to: directArguments.argument(at: 0, as: ArgumentType.languagePreference)
        )
      }
    )
  #endif
}
