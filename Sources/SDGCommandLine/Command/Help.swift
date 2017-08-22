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

    private static let helpName = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
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

    private static let helpDescription = UserFacingText({ (localization: ContentLocalization, _: Void) -> StrictString in
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

    static let help = Command(name: helpName, description: helpDescription, execution: { (output: inout Command.Output) throws -> Void in
        print("", to: &output)

        let stack = Command.stack.dropLast() // Ignoring help.
        let command = stack.last!
        print(StrictString(stack.map({ $0.localizedName() }).joined(separator: StrictString(" "))).formattedAsSubcommand() + " " + command.localizedDescription(), to: &output)

        if ¬command.subcommands.isEmpty {

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
            }).resolved().formattedAsSectionHeader(), to: &output)

            var subcommandEntries: [StrictString: StrictString] = [:]
            for subcommand in command.subcommands {
                let name = subcommand.localizedName()
                subcommandEntries[name] = name.formattedAsSubcommand() + " " + subcommand.localizedDescription()
            }

            for name in subcommandEntries.keys.sorted() {
                print(subcommandEntries[name]!, to: &output)
            }

        }

        print("", to: &output)
    }, addHelp: /* prevents circularity */ false)
}
