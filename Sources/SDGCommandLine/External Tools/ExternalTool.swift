/*
 ExternalTool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

internal typealias ExternalTool = _ExternalTool
/// :nodoc: (Shared to Workspace.)
public class _ExternalTool {

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

    internal func execute(with arguments: [StrictString], output: inout Command.Output, silently: Bool = false, autoquote: Bool = true) throws -> StrictString {
        return try _execute(with: arguments, output: &output, silently: silently, autoquote: autoquote)
    }
    /// :nodoc: (Shared to Workspace.)
    public func _execute(with arguments: [StrictString], output: inout Command.Output, silently: Bool, autoquote: Bool) throws -> StrictString {
        return StrictString(try _executeInCompatibilityMode(with: arguments.map({ String($0) }), output: &output, silently: silently, autoquote: autoquote))
    }

    internal func executeInCompatibilityMode(with arguments: [String], output: inout Command.Output, silently: Bool = false, autoquote: Bool = true) throws -> String {
        return try _executeInCompatibilityMode(with: arguments, output: &output, silently: silently, autoquote: autoquote)
    }
    /// :nodoc: (Shared to Workspace.)
    public func _executeInCompatibilityMode(with arguments: [String], output: inout Command.Output, silently: Bool, autoquote: Bool) throws -> String {
        try checkVersionOnce(output: &output)
        return try Shell.default.run(command: ([String(command)] + arguments), silently: silently, autoquote: autoquote, alternatePrint: { print($0, to: &output) })
    }
}
