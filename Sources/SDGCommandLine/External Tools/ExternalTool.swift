/*
 ExternalTool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGExternalProcess

import SDGCommandLineLocalizations

internal typealias ExternalTool = _ExternalTool
/// :nodoc: (Shared to Workspace.)
public class _ExternalTool {

    // MARK: - Static Properties

    // MARK: - Initialization

    internal init(name: UserFacing<StrictString, InterfaceLocalization>, webpage: UserFacing<StrictString, InterfaceLocalization>, command: StrictString, version: Version, versionCheck: [StrictString]) {
        self.name = name
        self.webpage = webpage
        self.command = command
        self.version = version
        self.versionCheck = versionCheck
    }

    // MARK: - Properties

    private let name: UserFacing<StrictString, InterfaceLocalization>
    private let webpage: UserFacing<StrictString, InterfaceLocalization>
    private let command: StrictString
    private let version: Version
    private let versionCheck: [StrictString]
    private var hasValidatedVersion = false

    // MARK: - Usage

    private func checkVersionOnce(output: Command.Output) throws {
        if ¬hasValidatedVersion {
            hasValidatedVersion = true

            try checkVersion(output: output)
        }
    }

    internal func checkVersion(output: Command.Output) throws {
        do {
            let commandLine = ([command] + versionCheck).map({ String($0) })

            output.print("")
            let versionOutput = StrictString(try Shell.default.run(command: commandLine, reportProgress: { output.print($0) }))
            output.print("")

            if let installedVersion = Version(firstIn: String(versionOutput)),
                installedVersion == version {
                return
            } else {
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    let name = self.name.resolved(for: localization)
                    let version = self.version.string
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Expected \(name) \(version). Attempting to continue anyway...")
                    }
                }).resolved().formattedAsWarning())
            }
        } catch {
            // version check failed
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                let name = self.name.resolved(for: localization)
                let url = self.webpage.resolved(for: localization).in(Underline.underlined)
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return StrictString("\(name) is required. See \(url).")
                }
            }))
        }
    }

    internal func execute(with arguments: [StrictString], output: Command.Output, silently: Bool = false, autoquote: Bool = true) throws -> StrictString {
        return try _execute(with: arguments, output: output, silently: silently, autoquote: autoquote)
    }
    /// :nodoc: (Shared to Workspace.)
    public func _execute(with arguments: [StrictString], output: Command.Output, silently: Bool, autoquote: Bool) throws -> StrictString {
        return StrictString(try _executeInCompatibilityMode(with: arguments.map({ String($0) }), output: output, silently: silently, autoquote: autoquote))
    }

    internal func executeInCompatibilityMode(with arguments: [String], output: Command.Output, silently: Bool = false, autoquote: Bool = true) throws -> String {
        return try _executeInCompatibilityMode(with: arguments, output: output, silently: silently, autoquote: autoquote)
    }
    /// :nodoc: (Shared to Workspace.)
    public func _executeInCompatibilityMode(with arguments: [String], output: Command.Output, silently: Bool, autoquote: Bool) throws -> String {
        try checkVersionOnce(output: output)
        if silently {
            return try Shell.default.run(command: ([String(command)] + arguments), autoquote: autoquote, reportProgress: {_ in })
        } else {
            output.print("")
            let result = try Shell.default.run(command: ([String(command)] + arguments), autoquote: autoquote, reportProgress: { output.print($0) })
            output.print("")
            return result
        }
    }
}
