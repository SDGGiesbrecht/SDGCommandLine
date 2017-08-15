/*
 Command.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

/// A command.
public struct Command {

    // MARK: - Initialization

    /// Creates a command.
    ///
    /// Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
    ///
    /// - Parameters:
    ///     - name: The name.
    ///     - description: A brief description. (Printed by the `help` subcommand.)
    ///     - execution: A closure to run for the command’s execution. The closure should indicate success by merely returning, and failure by throwing an instance of `Command.Error`. (Do not call `exit()` or other `Never`‐returning functions.)
    ///     - output: The stream for standard output. Use `print(..., to: &output)` for all output that should be captured as part of the return value of `execute()`.
    public init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, execution: @escaping (_ output: inout Command.Output) throws -> Void) {
        self.init(name: name, description: description, execution: execution, subcommands: [])
    }

    /// Creates an umbrella command.
    ///
    /// Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
    ///
    /// - Parameters:
    ///     - name: The name.
    ///     - description: A brief description. (Printed by the `help` subcommand.)
    ///     - subcommands: The subcommands.
    ///     - defaultSubcommand: The subcommand to execute if no subcommand is specified. (This should be an entry from `subcommands`.) Pass `nil` or leave this argument out to default to the help subcommand.
    public init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, subcommands: [Command], defaultSubcommand: Command? = nil) {
        self.init(name: name, description: description, execution: defaultSubcommand?.execution, subcommands: subcommands)
    }

    private static func normalizeToUnicode<L : Localization>(_ string: StrictString, in localization: L) -> StrictString {
        let hyphen: StrictString
        if let contentLocalization = ContentLocalization(reasonableMatchFor: localization.code) {
            switch contentLocalization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα:
                hyphen = "‐"
            case .עברית־ישראל:
                hyphen = "־"
            }
        } else {
            hyphen = "‐"
        }
        return string.replacingMatches(for: StrictString("\u{2D}"), with: hyphen)
    }

    private static func normalizeToAscii(_ string: StrictString) -> StrictString {
        let asciiHyphen: StrictString = "\u{2D}"
        var result = string
        result.replaceMatches(for: StrictString("‐"), with: asciiHyphen)
        result.replaceMatches(for: StrictString("־"), with: asciiHyphen)
        return result
    }

    private static func list<L : InputLocalization>(names: UserFacingText<L, Void>) -> Set<StrictString> {
        var result: Set<StrictString> = []
        for localization in L.cases {
            let name = names.resolved(for: localization)
            result.insert(Command.normalizeToUnicode(name, in: localization))
            result.insert(Command.normalizeToAscii(name))
        }
        return result
    }

    private init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, execution: ((_ output: inout Command.Output) throws -> Void)?, subcommands: [Command]) {
        var actualSubcommands = subcommands

        let help = Command(helpForName: name, subcommands: actualSubcommands)
        actualSubcommands.append(help)

        self.localizedName = { return name.resolved() }
        self.names = Command.list(names: name)
        self.localizedDescription = { return description.resolved() }
        self.execution = execution ?? { _ in try help.execute(with: []) }
        self.subcommands = actualSubcommands
    }

    internal init<L : InputLocalization>(helpForName name: UserFacingText<L, Void>, subcommands: [Command]) {
        let help = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "help"
            case .deutschDeutschland:
                return "hilfe"
            case .françaisFrance:
                return "aide"
            case .ελληνικάΕλλάδα:
                return "βοήθεια"
            case .עברית־ישראל:
                return "עזרה"
            }
        })
        let helpDescription = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "displays usage information."
            case .deutschDeutschland:
                return "zeigt Verwendungsinformationen."
            case .françaisFrance:
                return "affiche de l’information sur l’utilization."
            case .ελληνικάΕλλάδα:
                return "εκθέτει πληροφορίες του χρήσης."
            case .עברית־ישראל:
                return "מציגה את מידה השימוש."
            }
        })

        self.localizedName = { return help.resolved() }
        self.names = Command.list(names: help)
        self.localizedDescription = { return helpDescription.resolved() }
        self.subcommands = []
        self.execution = { (output: inout Command.Output) throws -> Void in
            // [_Workaround: Help should have improved formatting and colour._]
            print("", to: &output)

            let command = Command.stack.dropLast() // Ignoring help.
            print(StrictString(command.map({ $0.localizedName() }).joined(separator: StrictString(" "))), to: &output)

            print("", to: &output)

            print(UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Subcommands"
                case .deutschDeutschland:
                    return "Unterbefehle"
                case .françaisFrance:
                    return "Sous‐commandes"
                case .ελληνικάΕλλάδα:
                    return "Υπεντολές"
                case .עברית־ישראל:
                    return "תת פקודות"
                }
            }).resolved(), to: &output)

            print("", to: &output)

            var subcommandEntries: [StrictString: StrictString] = [:]
            func addSubcommandEntry(name: () -> StrictString) {
                let subcommandName = name()
                subcommandEntries[subcommandName] = subcommandName // [_Warning: This should append a description._]
            }

            for subcommand in subcommands {
                addSubcommandEntry(name: subcommand.localizedName)
            }
            addSubcommandEntry(name: { help.resolved() })

            for subcommandName in subcommandEntries.keys.sorted() {
                print(subcommandEntries[subcommandName]!, to: &output)
            }

            print("", to: &output)
        }
    }

    // MARK: - Static Properties

    private static var stack: [Command] = []

    // MARK: - Properties

    private let names: Set<StrictString>
    private let localizedName: () -> StrictString
    private let localizedDescription: () -> StrictString

    private let execution: (_ output: inout Command.Output) throws -> Void
    private let subcommands: [Command]

    // MARK: - Execution

    /// Executes the command and exits.
    public func executeAsMain() -> Never {
        let arguments = CommandLine.arguments.dropFirst().map() { StrictString($0) }

        do {
            try execute(with: arguments)
            exit(Int32(Error.successCode))
        } catch let error as Command.Error {
            // [_Workaround: Errors should have improved formatting and colour._]
            FileHandle.standardError.write((error.describe() + "\n").file)
            exit(Int32(truncatingBitPattern: error.exitCode))
        } catch {
            // [_Workaround: Errors should have improved formatting and colour._]
            FileHandle.standardError.write((error.localizedDescription + "\n").file)
            exit(Int32(truncatingBitPattern: Error.generalErrorCode))
        }
    }

    /// Executes the command without exiting.
    ///
    /// - Parameters:
    ///     - arguments: The command line arguments, including subcommands and options, to use. (The command itself should be left out.)
    ///
    /// - Returns: The output. (For output to be captured properly, it must printed to the provided stream. See `init(name:execution:)`.)
    ///
    /// - Throws: Whatever error is thrown by the `execution` closure provided when the command was initialized.
    @discardableResult public func execute(with arguments: [StrictString]) throws -> StrictString {

        Command.stack.append(self)
        defer { Command.stack.removeLast() }

        if let first = arguments.first {
            for subcommand in subcommands where first ∈ subcommand.names {
                return try subcommand.execute(with: Array(arguments.dropFirst()))
            }
        }

        var output = Output()
        try execution(&output)
        return output.output
    }
}
