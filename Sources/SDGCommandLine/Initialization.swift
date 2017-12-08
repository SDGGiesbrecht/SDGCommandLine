/*
 Initialization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

/// Initializes SDGCommandLine and SDGCornerstone. Call this before calling anything else from SDGCommandLine.
///
/// - Parameters:
///     - applicationIdentifier: An application identifier in reverse domain form (tld.Developper.Tool).
///     - version: The semantic version of the tool’s package. This will be displayed by the `version` subcommand. It is recommended to set this to `nil` in between stable releases.
///     - packageURL: The URL of the tool’s Swift package. This is where the `•use‐version` option will look for other versions. The specified repository must be a valid Swift package that builds successfully with nothing more than `swift build`. If the repository is not publicly available or not a Swift package, this parameter should be `nil`, in which case the `•use‐version` option will be unavailable.
///     - applicationPreferencesClass: A subclass of `SDGCornerstone.Preferences` to use for the application preferences instance. Defaults to the `Preferences` class itself.
public func initialize(applicationIdentifier: String, version: Version?, packageURL: URL?, applicationPreferencesClass: Preferences.Type = Preferences.self) {

    SDGCornerstone.initialize(mode: .commandLineTool, applicationIdentifier: applicationIdentifier, applicationPreferencesClass: applicationPreferencesClass)

    Version.currentToolVersion = version

    if let url = packageURL { // [_Exempt from Code Coverage_]
        Package.current = Package(url: url)
    }
}

private var warnedLocalizations: Set<InterfaceLocalization> = []
internal func warnAboutSecondLanguages<T : TextOutputStream>(_ output: inout T) {

    if BuildConfiguration.current == .debug {
        let localization = LocalizationSetting.current.value.resolved() as InterfaceLocalization
        if localization ∉ Set<InterfaceLocalization>([
            .englishUnitedKingdom,
            .englishUnitedStates,
            .englishCanada]),
            localization ∉ warnedLocalizations {

            warnedLocalizations.insert(localization)

            let warning = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    unreachable()
                case .deutschDeutschland:
                    return "Achtung: Das Deutsch von SDGCommandLine ist noch von keinem Muttersprachler geprüft worden. Falls Sie dabei helfen möchten, melden Sie sich unter:"
                case .françaisFrance:
                    return "Attention : Le français de SDGCommandLine n’a pas été vérifié par un locuteur natif. Si vous voudriez nous aider, inscrivez‐vous par ici :"
                case .ελληνικάΕλλάδα:
                    return "Προειδοποίηση: Τα ελληνικά του SDGCommandLine δεν ελέγχεται από ενός φυσικού ομιλητή. Αν θέλετε να μας βοηθήσετε, εγγράψτε εδώ:"
                case .עברית־ישראל:
                    /*א*/ return "זהירות: העברית של SDGCommandLine לא נבדקה אל יד של דובר שפת אם. אם אתה/את רוצה לעזור לנו, הירשם/הירשמי כאן:"
                }
            })
            let issueTitle = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    unreachable()
                case .deutschDeutschland:
                    return "Deutsch prüfen"
                case .françaisFrance:
                    return "Vérifier le français"
                case .ελληνικάΕλλάδα:
                    return "Έλεγχος των ελληνικών"
                case .עברית־ישראל:
                    return "בדיקה של העברית"
                }
            })
            let issueBody = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    unreachable()
                case .deutschDeutschland:
                    return "Ich würde gern helfen. Bitte erklären Sie mir wie."
                case .françaisFrance:
                    return "Je voudrais assister. S’il vous plaît, expliquez‐moi comment."
                case .ελληνικάΕλλάδα:
                    return "Θα ήθελα να βοηθήσω. Παρακαλώ, εξηγήστε πώς."
                case .עברית־ישראל:
                    return "אני רוצה לעזור. נא הסבר איך."
                }
            })
            var message: StrictString = "⚠ "
            message += warning.resolved()
            message += "\n"
            message += "https://github.com/SDGGiesbrecht/SDGCommandLine/issues/new?title="
            message += StrictString(String(issueTitle.resolved()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            message += "&body="
            message += StrictString(String(issueBody.resolved()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            print(message.formattedAsWarning(), to: &output)
        }
    }
}
