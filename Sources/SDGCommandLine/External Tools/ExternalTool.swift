/*
 ExternalTool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

internal class ExternalTool {

    // MARK: - Static Properties

    // MARK: - Initialization

    internal init(name: UserFacingText<InterfaceLocalization, Void>, webpage: UserFacingText<InterfaceLocalization, Void>, command: StrictString, version: Version, versionCheck: [StrictString]) {
        self.name = name
        self.webpage = webpage
        self.command = command
        self.version = version
        self.versionCheck = versionCheck
    }

    // MARK: - Properties

    private let name: UserFacingText<InterfaceLocalization, Void>
    private let webpage: UserFacingText<InterfaceLocalization, Void>
    private let command: StrictString
    private let version: Version
    private let versionCheck: [StrictString]
    private var hasValidatedVersion = false

    // MARK: - Usage

    private func checkVersionOnce(output: inout Command.Output) throws {
        if ¬hasValidatedVersion {
            hasValidatedVersion = true

            try checkVersion(output: &output)
        }
    }

    internal func checkVersion(output: inout Command.Output) throws {
        do {
            let commandLine = ([command] + versionCheck).map({ String($0) })
            let versionOutput = StrictString(try Shell.default.run(command: commandLine, alternatePrint: { print($0, to: &output) }))

            if let installedVersion = Version(firstIn: String(versionOutput)),
                installedVersion == version {
                return
            } else {
                print(UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                    let name = self.name.resolved(for: localization)
                    let version = self.version.string
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Expected \(name) \(version). Attempting to continue anyway...")
                    case .deutschDeutschland:
                        return StrictString("\(name) \(version) erwartet. Versucht trotzdem weiter ...")
                    case .françaisFrance:
                        return StrictString("\(name) \(version) attendu. Tente de continuer quand même...")
                    case .ελληνικάΕλλάδα:
                        return StrictString("\(name) \(version) αναμενότανε. Προσπαθεί να συνεχίζει ούτος ή άλλως...")
                    case .עברית־ישראל:
                        /*א*/ return StrictString("ציפה את \(name) \(version). מנסה להמשיך בכל זאת...")
                    }
                }).resolved().formattedAsWarning(), to: &output)
            }
        } catch {
            // version check failed
            throw Command.Error(description: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                let name = self.name.resolved(for: localization)
                let url = self.webpage.resolved(for: localization).in(Underline.underlined)
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return StrictString("\(name) is required. See \(url).")
                case .deutschDeutschland:
                    return StrictString("\(name) wird benötigt. Siehe \(url).")
                case .françaisFrance:
                    return StrictString("\(name) est requis. Voir \(url).")
                case .ελληνικάΕλλάδα:
                    return StrictString("\(name) απαραιτείται. Βλέπε \(url).")
                case .עברית־ישראל:
                     /*א*/ return StrictString("\(name) נחוץ. ראה \(url).")
                }
            }))
        }
    }

    internal func execute(with arguments: [StrictString], output: inout Command.Output) throws -> StrictString {
        try checkVersionOnce(output: &output)
        return StrictString(try Shell.default.run(command: ([command] + arguments).map({ String($0) }), alternatePrint: { print($0, to: &output) }))
    }
}
