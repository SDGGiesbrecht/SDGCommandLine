/*
 Help.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics

extension Command {

    private static let helpName = UserFacingText({ (localization: SystemLocalization) -> StrictString in
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

    private static let helpDescription = UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "displays usage information."
        }
    })

    internal static let help = Command(name: helpName, description: helpDescription, directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in
        output.print("")

        let stack = Command.stack.dropLast() // Ignoring help.
        let command = stack.last!

        let formatType = { (type: StrictString) -> StrictString in
            return ("[" + type + "]").formattedAsType()
        }

        var commandName = StrictString(stack.map({ $0.localizedName() }).joined(separator: StrictString(" "))).formattedAsSubcommand()
        for directArgument in command.directArguments {
            commandName += " " + formatType(directArgument.localizedName())
        }
        output.print(commandName + " " + command.localizedDescription())

        func printSection<T>(header: UserFacingText<InterfaceLocalization>, entries: [T], getHeadword: (T) -> StrictString, getFormattedHeadword: (T) -> StrictString, getDescription: (T) -> StrictString) {

            output.print(header.resolved().formattedAsSectionHeader())

            var entryText: [StrictString: StrictString] = [:]
            for entry in entries {
                entryText[getHeadword(entry)] = getFormattedHeadword(entry) + " " + getDescription(entry)
            }

            for headword in entryText.keys.sorted() {
                output.print(entryText[headword]!)
            }
        }

        if ¬command.subcommands.isEmpty {

            printSection(header: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Subcommands"
                }
            }), entries: command.subcommands, getHeadword: { $0.localizedName() }, getFormattedHeadword: { $0.localizedName().formattedAsSubcommand() + $0.directArguments.map({ " " + formatType($0.localizedName()) }).joined() }, getDescription: { $0.localizedDescription() })
        }

        if ¬command.options.isEmpty {

            let formatOption = { (option: AnyOption) -> StrictString in
                var result = ("•" + option.localizedName()).formattedAsOption()
                if option.type().identifier() ≠ ArgumentType.booleanKey {
                    result += " " + formatType(option.type().localizedName())
                }
                return result
            }

            printSection(header: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Options"
                }
            }), entries: command.options, getHeadword: { $0.localizedName() }, getFormattedHeadword: formatOption, getDescription: { $0.localizedDescription() })

            var argumentTypes: [StrictString: (type: StrictString, description: StrictString)] = [:]
            for type in command.directArguments + command.options.map({ $0.type() }) {
                let key = type.identifier()
                if key ≠ ArgumentType.booleanKey {
                    argumentTypes[key] = (type: type.localizedName(), description: type.localizedDescription())
                }
            }
            printSection(header: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Argument Types"
                }
            }), entries: Array(argumentTypes.values), getHeadword: { $0.type }, getFormattedHeadword: { formatType($0.type) }, getDescription: { $0.description })
        }

        output.print("")
    }, addHelp: /* prevents circularity */ false)
}
