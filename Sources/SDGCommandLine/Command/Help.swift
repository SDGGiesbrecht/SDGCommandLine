/*
 Help.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics

import SDGCommandLineLocalizations

extension Command {

    private static let helpName = UserFacing<StrictString, SystemLocalization>({ localization in
        switch localization {
        case .普通话中国:
            return "帮助"
        case .國語中國:
            return "輔助說明"

        case .españolEspaña:
            return "ayuda"
        case .portuguêsPortugal, .catalàEspanya:
            return "ajuda"
        case .françaisFrance:
            return "aide"
        case .italianoItalia:
            return "aiuto"
        case .românăRomânia:
            return "ajutor"

        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .nederlandsNederland:
            return "help"
        case .日本語日本国:
            return "ヘルプ"
        case .deutschDeutschland:
            return "hilfe"
        case .svenskaSverige:
            return "hjälp"
        case .danskDanmark:
            return "hjælp"
        case .norskNorge:
            return "hjelp"

        case .العربية_السعودية:
            return "مساعدة"

        case .हिन्दी_भारत:
            return "सहायता"

        case .русскийРоссия:
            return "справка"

        case .tiếngViệtViệtNam:
            return "trợ giúp"

        case .한국어한국:
            return "도움말"

        case .türkçeTürkiye:
            return "yardım"

        case .polskiPolska:
            return "pomoc"
        case .slovenčinaSlovensko:
            return "pomocník"
        case .hrvatskiHrvatska:
            return "pomoć"

        case .українськаУкраїна:
            return "довідка"

        case .malaysiaMalaysia, .indonesiaIndonesia:
            return "bantuan"

        case .ไทยไทย:
            return "วิธีใช้"

        case .češtinaČesko:
            return "nápověda"

        case .magyarMagyarország:
            return "súgó"

        case .ελληνικάΕλλάδα:
            return "βοήθεια"

        case .suomiSuomi:
            return "ohje"

        case .עברית־ישראל:
            return "עזרה"
        }
    })

    private static let helpDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
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

        func printSection<T>(header: UserFacing<StrictString, InterfaceLocalization>, entries: [T], getHeadword: (T) -> StrictString, getFormattedHeadword: (T) -> StrictString, getDescription: (T) -> StrictString) {

            output.print(header.resolved().formattedAsSectionHeader())

            var entryText: [StrictString: StrictString] = [:]
            for entry in entries {
                entryText[getHeadword(entry)] = getFormattedHeadword(entry) + " " + getDescription(entry)
            }

            for headword in entryText.keys.sorted() {
                output.print(entryText[headword]!)
            }
        }

        let subcommands = command.subcommands.filter { ¬$0.isHidden }
        if ¬subcommands.isEmpty {

            printSection(header: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Subcommands"
                }
            }), entries: subcommands, getHeadword: { $0.localizedName() }, getFormattedHeadword: { $0.localizedName().formattedAsSubcommand() + $0.directArguments.map({ " " + formatType($0.localizedName()) }).joined() }, getDescription: { $0.localizedDescription() })
        }

        if ¬command.options.isEmpty {

            let formatOption = { (option: AnyOption) -> StrictString in
                var result = ("•" + option.localizedName()).formattedAsOption()
                if option.type().identifier() ≠ ArgumentType.booleanIdentifier {
                    result += " " + formatType(option.type().localizedName())
                }
                return result
            }

            printSection(header: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Options"
                }
            }), entries: command.options.filter({ ¬$0.isHidden }), getHeadword: { $0.localizedName() }, getFormattedHeadword: formatOption, getDescription: { $0.localizedDescription() })

            var argumentTypes: [StrictString: (type: StrictString, description: StrictString)] = [:]
            for type in command.directArguments + command.options.map({ $0.type() }) {
                let key = type.identifier()
                if key ≠ ArgumentType.booleanIdentifier {
                    argumentTypes[key] = (type: type.localizedName(), description: type.localizedDescription())
                }
            }
            printSection(header: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Argument Types"
                }
            }), entries: Array(argumentTypes.values), getHeadword: { $0.type }, getFormattedHeadword: { formatType($0.type) }, getDescription: { $0.description })
        }

        output.print("")
    }, addHelp: /* prevents circularity */ false)
}
