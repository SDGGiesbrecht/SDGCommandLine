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

    // MARK: - Static Properties

    private static var standardOptions: [AnyOption] {
        var options: [AnyOption] = [
            Options.noColour,
            Options.language
        ]
        if Package.current ≠ nil {
            options.append(Options.useVersion)
        }
        return options
    }

    // MARK: - Initialization

    /// Creates a command.
    ///
    /// - Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
    ///
    /// - Parameters:
    ///     - name: The name.
    ///     - description: A brief description. (Printed by the `help` subcommand.)
    ///     - directArguments: A list of direct command line arguments to accept.
    ///     - options: A list of command line options to accept.
    ///     - execution: A closure to run for the command’s execution. The closure should indicate success by merely returning, and failure by throwing an instance of `Command.Error`. (Do not call `exit()` or other `Never`‐returning functions.)
    ///     - parsedDirectArguments: The parsed direct arguments.
    ///     - parsedOptions: The parsed options.
    ///     - output: The stream for standard output. Use `print(..., to: &output)` for everything intendend for standard output. Anything printed by other means will not be filtered by `•no‐colour`, not be captured for the return value of `execute()` and not be available to any other specialized handling.
    public init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, directArguments: [AnyArgumentTypeDefinition], options: [AnyOption], execution: @escaping (_ parsedDirectArguments: DirectArguments, _ parsedOptions: Options, _ output: inout Command.Output) throws -> Void) {
        self.init(name: name, description: description, directArguments: directArguments, options: options, execution: execution, subcommands: [])
    }

    /// Creates an umbrella command.
    ///
    /// - Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
    ///
    /// - Parameters:
    ///     - name: The name.
    ///     - description: A brief description. (Printed by the `help` subcommand.)
    ///     - subcommands: The subcommands.
    ///     - defaultSubcommand: The subcommand to execute if no subcommand is specified. (This should be an entry from `subcommands`.) Pass `nil` or leave this argument out to default to the help subcommand.
    public init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, subcommands: [Command], defaultSubcommand: Command? = nil) {
        self.init(name: name, description: description, directArguments: defaultSubcommand?.directArguments ?? [], options: defaultSubcommand?.options ?? [], execution: defaultSubcommand?.execution, subcommands: subcommands)
    }

    internal init<L : InputLocalization>(name: UserFacingText<L, Void>, description: UserFacingText<L, Void>, directArguments: [AnyArgumentTypeDefinition], options: [AnyOption], execution: ((_ parsedDirectArguments: DirectArguments, _ parsedOptions: Options, _ output: inout Command.Output) throws -> Void)?, subcommands: [Command] = [], addHelp: Bool = true) {
        var actualSubcommands = subcommands

        if addHelp {
            actualSubcommands.append(Command.help)
        }

        localizedName = { return Command.normalizeToUnicode(name.resolved(), in: LocalizationSetting.current.value.resolved() as L) }
        names = Command.list(names: name)
        localizedDescription = { return description.resolved() }
        self.execution = execution ?? { (_, _, _) in try Command.help.execute(with: []) }
        self.subcommands = actualSubcommands
        self.directArguments = directArguments
        self.options = options.appending(contentsOf: Command.standardOptions)
    }

    // MARK: - Properties

    internal private(set) static var stack: [Command] = []

    private let names: Set<StrictString>
    internal let localizedName: () -> StrictString
    internal let localizedDescription: () -> StrictString

    private let execution: (_ parsedDirectArguments: DirectArguments, _ parsedOptions: Options, _ output: inout Command.Output) throws -> Void
    internal var subcommands: [Command]
    internal let directArguments: [AnyArgumentTypeDefinition]
    internal let options: [AnyOption]

    // MARK: - Execution

    internal func withRootBehaviour() -> Command {
        var copy = self
        copy.subcommands.append(contentsOf: [
            Command.version,
            Command.setLanguage
            ])
        return copy
    }

    /// Executes the command and exits.
    public func executeAsMain() -> Never { // [_Exempt from Code Coverage_] Not testable.

        let arguments = CommandLine.arguments.dropFirst().map() { StrictString($0) } // [_Exempt from Code Coverage_]

        do { // [_Exempt from Code Coverage_]
            try self.withRootBehaviour().execute(with: arguments)
            exit(Int32(Error.successCode))
        } catch let error as Command.Error { // [_Exempt from Code Coverage_]
            FileHandle.standardError.write((error.describe().formattedAsError() + "\n").file)
            exit(Int32(truncatingIfNeeded: error.exitCode))
        } catch { // [_Exempt from Code Coverage_]
            FileHandle.standardError.write((error.localizedDescription.formattedAsError() + "\n").file)
            exit(Int32(truncatingIfNeeded: Error.generalErrorCode))
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
        var output = Output()

        if let package = Package.current,
            let (version, otherArguments) = try parseVersion(from: arguments),
            version ≠ Build.current {

            try package.execute(version, of: names, with: otherArguments, output: &output)
            return output.output
        }

        Command.stack.append(self)
        defer { Command.stack.removeLast() }

        if let first = arguments.first {
            for subcommand in subcommands where first ∈ subcommand.names {
                return try subcommand.execute(with: Array(arguments.dropFirst()))
            }
        }

        let (directArguments, options) = try parse(arguments: arguments)

        if options.value(for: Options.noColour) {
            output.filterFormatting = true
        }

        let language = options.value(for: Options.language) ?? LocalizationSetting.current.value
        try language.do {

            warnAboutSecondLanguages(&output)

            try execution(directArguments, options, &output)
        }
        return output.output
    }

    // MARK: - Argument Parsing

    private func parse(arguments: [StrictString]) throws -> (DirectArguments, Options) {
        var directArguments = DirectArguments()
        var options = Options()

        var remaining: ArraySlice<StrictString> = arguments[arguments.bounds]
        var expected: ArraySlice<AnyArgumentTypeDefinition> = self.directArguments[self.directArguments.bounds]
        while let argument = remaining.popFirst() {

            if ¬(try parse(possibleOption: argument, remainingArguments: &remaining, parsedOptions: &options)) {

                // Not an option.

                if ¬(try parse(possibleDirectArgument: argument, parsedDirectArguments: &directArguments, expectedDirectArguments: &expected)) {

                    // Not a direct argument.

                    let commandStack = Command.stack // Prevent delayed evaluation.
                    throw Command.Error(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
                        var result: StrictString
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            result = StrictString("Unexpected argument: \(argument)")
                        case .deutschDeutschland:
                            result = StrictString("Unerwartetes Argument: \(argument)")
                        case .françaisFrance:
                            result = StrictString("Argument inattendu : \(argument)")
                        case .ελληνικάΕλλάδα:
                            result = StrictString("Απροσδόκητο όρισμα: \(argument)")
                        case .עברית־ישראל:
                            result = StrictString("ארגומנט לא צפוי: \(argument)")
                        }
                        return result + "\n" + Command.helpInstructions(for: commandStack).resolved(for: localization)
                    }))
                }
            }
        }
        return (directArguments, options)
    }

    private func parse(possibleDirectArgument: StrictString, parsedDirectArguments: inout DirectArguments, expectedDirectArguments: inout ArraySlice<AnyArgumentTypeDefinition>) throws -> Bool {

        guard let definition = expectedDirectArguments.popFirst() else {
            return false // Not a direct argument.
        }

        guard let parsed = definition.parse(argument: possibleDirectArgument) else {
            let commandStack = Command.stack // Prevent delayed evaluation.
            throw Command.Error(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
                let commandName = self.localizedName()
                var result: StrictString
                switch localization {
                case .englishUnitedKingdom:
                    result = StrictString("An argument for ‘\(commandName)’ is invalid: \(possibleDirectArgument)")
                case .englishUnitedStates, .englishCanada:
                    result = StrictString("An argument for “\(commandName)” is invalid: \(possibleDirectArgument)")
                case .deutschDeutschland:
                    result = StrictString("Ein Argument für „\(commandName)“ ist ungültig: \(possibleDirectArgument)")
                case .françaisFrance:
                    result = StrictString("Un argument pour « \(commandName) » est invalide : \(possibleDirectArgument)")
                case .ελληνικάΕλλάδα:
                    result = StrictString("Ένα όρισμα για «\(commandName)» είναι άκυρο: \(possibleDirectArgument)")
                case .עברית־ישראל:
                    /*א*/ result = StrictString("ארגומנט ל־”\(commandName)“ לא בתוקף: \(possibleDirectArgument)")
                }
                return result + "\n" + Command.helpInstructions(for: commandStack).resolved(for: localization)
            }))
        }

        parsedDirectArguments.add(value: parsed)
        return true
    }

    private func removeOptionMarker(from possibleOption: StrictString) -> StrictString? {
        for marker in Option<Any>.optionMarkers where possibleOption.hasPrefix(marker) {
            return possibleOption.dropping(through: marker)
        }
        return nil
    }

    private func parse(possibleOption: StrictString, remainingArguments: inout ArraySlice<StrictString>, parsedOptions: inout Options) throws -> Bool {

        guard let name = removeOptionMarker(from: possibleOption) else {
            // Not an option.
            return false
        }

        for option in options where option.matches(name: name) {

            if option.getType().getIdentifier() == ArgumentType.booleanKey {
                // Boolean flags take no arguments.
                parsedOptions.add(value: true, for: option)
                return true
            }

            guard let argument = remainingArguments.popFirst() else {
                let commandStack = Command.stack // Prevent delayed evaluation.
                throw Command.Error(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
                    let optionName = ("•" + option.getLocalizedName())
                    var result: StrictString
                    switch localization {
                    case .englishUnitedKingdom:
                        result = StrictString("The argument is missing for ‘\(optionName)’.")
                    case .englishUnitedStates, .englishCanada:
                        result = StrictString("The argument is missing for “\(optionName)”.")
                    case .deutschDeutschland:
                        result = StrictString("Das Argument fehlt für „\(optionName)“.")
                    case .françaisFrance:
                        result = StrictString("L’argument manque pour « \(optionName) ».")
                    case .ελληνικάΕλλάδα:
                        result = StrictString("Το όρισμα λείπει από «\(optionName)»")
                    case .עברית־ישראל:
                        result = StrictString("הארגומנט חסר ל־”\(optionName)“")
                    }
                    return result + "\n" + Command.helpInstructions(for: commandStack).resolved(for: localization)
                }))
            }

            guard let parsed = option.getType().parse(argument: argument) else {
                let commandStack = Command.stack // Prevent delayed evaluation.
                throw Command.Error(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
                    let optionName = ("•" + option.getLocalizedName())
                    var result: StrictString
                    switch localization {
                    case .englishUnitedKingdom:
                        result = StrictString("The argument for ‘\(optionName)’ is invalid: \(argument)")
                    case .englishUnitedStates, .englishCanada:
                        result = StrictString("The argument for “\(optionName)” is invalid: \(argument)")
                    case .deutschDeutschland:
                        result = StrictString("Das Argument für „\(optionName)“ ist ungültig: \(argument)")
                    case .françaisFrance:
                        result = StrictString("L’argument pour « \(optionName) » est invalide : \(argument)")
                    case .ελληνικάΕλλάδα:
                        result = StrictString("Το όρισμα για «\(optionName)» είναι άκυρο: \(argument)")
                    case .עברית־ישראל:
                        /*א*/ result = StrictString("הארגומנט ל־”\(optionName)“ לא בתוקף: \(argument)")
                    }
                    return result + "\n" + Command.helpInstructions(for: commandStack).resolved(for: localization)
                }))
            }

            parsedOptions.add(value: parsed, for: option)
            return true
        }

        let commandStack = Command.stack // Prevent delayed evaluation.
        throw Command.Error(description: UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            let optionName = ("•" + name)
            var result: StrictString
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                result = StrictString("Invalid option: \(optionName)")
            case .deutschDeutschland:
                result = StrictString("Ungültige Option: \(optionName)")
            case .françaisFrance:
                result = StrictString("Option invalide : \(optionName)")
            case .ελληνικάΕλλάδα:
                result = StrictString("Άκυρη επιλογή: \(optionName)")
            case .עברית־ישראל:
                result = StrictString("בררה לא בתוקף: \(optionName)")
            }
            return result + "\n" + Command.helpInstructions(for: commandStack).resolved(for: localization)
        }))
    }

    private func parseVersion(from arguments: [StrictString]) throws -> (version: Build, otherArguments: [StrictString])? {

        var remaining = arguments[arguments.bounds]

        while let argument = remaining.popFirst() {

            if let name = removeOptionMarker(from: argument),
                Options.useVersion.matches(name: name) {

                var options = Options()
                if try parse(possibleOption: argument, remainingArguments: &remaining, parsedOptions: &options),
                    let version = options.value(for: Options.useVersion) {

                    let index = arguments.endIndex − remaining.count − 2
                    let otherArguments = Array(arguments[0 ..< index]) + Array(remaining)
                    return (version: version, otherArguments: otherArguments)
                }
            }
        }

        return nil
    }

    private static func helpInstructions(for commandStack: [Command]) -> UserFacingText<ContentLocalization, Void> {
        var command = StrictString(commandStack.map({ $0.localizedName() }).joined(separator: " ".scalars))
        command.append(contentsOf: " " + Command.help.localizedName())
        command = command.prepending(contentsOf: "$ ".scalars)

        return UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return StrictString("See also: \(command)")
            case .deutschDeutschland:
                return StrictString("Siehe auch: \(command)")
            case .françaisFrance:
                return StrictString("Voir aussi : \(command)")
            case .ελληνικάΕλλάδα:
                return StrictString("Βλέπε επίσης: \(command)")
            case .עברית־ישראל:
                return StrictString("ראה גם: \(command)")
            }
        })
    }

    // MARK: - Name Normalization

    internal static func normalizeToUnicode<L : Localization>(_ string: StrictString, in localization: L) -> StrictString {
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

    internal static func normalizeToAscii(_ string: StrictString) -> StrictString {
        let asciiHyphen: StrictString = "\u{2D}"
        var result = string
        result.replaceMatches(for: StrictString("‐"), with: asciiHyphen)
        result.replaceMatches(for: StrictString("־"), with: asciiHyphen)
        return result
    }

    internal static func list<L : InputLocalization>(names: UserFacingText<L, Void>) -> Set<StrictString> {
        var result: Set<StrictString> = []
        for localization in L.cases {
            let name = names.resolved(for: localization)
            result.insert(Command.normalizeToUnicode(name, in: localization))
            result.insert(Command.normalizeToAscii(name))
        }
        return result
    }
}
