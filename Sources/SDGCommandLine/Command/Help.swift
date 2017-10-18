/*
 Help.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Command {

    private static let helpName = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
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

    private static let helpDescription = UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
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

    internal static let help = Command(name: helpName, description: helpDescription, directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws -> Void in
        print("", to: &output)

        let stack = Command.stack.dropLast() // Ignoring help.
        let command = stack.last!

        let formatType = { (type: StrictString) -> StrictString in
            return ("[" + type + "]").formattedAsType()
        }

        var commandName = StrictString(stack.map({ $0.localizedName() }).joined(separator: StrictString(" "))).formattedAsSubcommand()
        for directArgument in command.directArguments {
            commandName += " " + formatType(directArgument.localizedName())
        }
        print(commandName + " " + command.localizedDescription(), to: &output)

        func printSection<T>(header: UserFacingText<InterfaceLocalization, Void>, entries: [T], getHeadword: (T) -> StrictString, getFormattedHeadword: (T) -> StrictString, getDescription: (T) -> StrictString) {

            print(header.resolved().formattedAsSectionHeader(), to: &output)

            var entryText: [StrictString: StrictString] = [:]
            for entry in entries {
                entryText[getHeadword(entry)] = getFormattedHeadword(entry) + " " + getDescription(entry)
            }

            for headword in entryText.keys.sorted() {
                print(entryText[headword]!, to: &output)
            }
        }

        if ¬command.subcommands.isEmpty {

            printSection(header: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
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

            printSection(header: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Options"
                case .deutschDeutschland:
                    return "Optionen"
                case .françaisFrance:
                    return "Options"
                case .ελληνικάΕλλάδα:
                    return "Επιλογές"
                case .עברית־ישראל:
                    return "ברירות"
                }
            }), entries: command.options, getHeadword: { $0.localizedName() }, getFormattedHeadword: formatOption, getDescription: { $0.localizedDescription() })

            var argumentTypes: [StrictString: (type: StrictString, description: StrictString)] = [:]
            for type in command.directArguments + command.options.map({ $0.type() }) {
                let key = type.identifier()
                if key ≠ ArgumentType.booleanKey {
                    argumentTypes[key] = (type: type.localizedName(), description: type.localizedDescription())
                }
            }
            printSection(header: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Argument Types"
                case .deutschDeutschland:
                    return "Argumentarten"
                case .françaisFrance:
                    return "Types d’argument"
                case .ελληνικάΕλλάδα:
                    return "Τύποι ορισμάτων"
                case .עברית־ישראל:
                    return "טיפוסי ארגומנטים"
                }
            }), entries: Array(argumentTypes.values), getHeadword: { $0.type }, getFormattedHeadword: { formatType($0.type) }, getDescription: { $0.description })
        }

        print("", to: &output)
    }, addHelp: /* prevents circularity */ false)
}
