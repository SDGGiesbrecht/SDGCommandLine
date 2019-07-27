/*
 Execute.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization

import SDGCommandLine

public enum Execute {

    public static let textOption = Option(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "string"
        case .deutsch:
            return "zeichenkette"
        }
    }), description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "Text to display."
        case .deutsch:
            return "Text zum Zeigen."
        }
    }), type: ArgumentType.string)

    private static let colourArgumentType = ArgumentType.enumeration(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "colour"
        case .deutsch:
            return "Farbe"
        }
    }), cases: [
        (Colour.red, UserFacing<StrictString, Language>({ localization in
            switch localization {
            case .english, .unsupported:
                return "red"
            case .deutsch:
                return "rot"
            }
        })),
        (Colour.green, UserFacing<StrictString, Language>({ localization in
            switch localization {
            case .english, .unsupported:
                return "green"
            case .deutsch:
                return "grün"
            }
        })),
        (Colour.blue, UserFacing<StrictString, Language>({ localization in
            switch localization {
            case .english, .unsupported:
                return "blue"
            case .deutsch:
                return "blau"
            }
        }))
        ])

    private static let colourOption = Option(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "colour"
        case .deutsch:
            return "farbe"
        }
    }), description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "A colour for the text."
        case .deutsch:
            return "Eine Farbe für den Text."
        }
    }), type: Execute.colourArgumentType)

    private static let iterationsOption = Option(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "iterations"
        case .deutsch:
            return "wiederholungen"
        }
    }), description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "The number of iterations."
        case .deutsch:
            return "Die Anzahl der Wiederholungen."
        }
    }), type: ArgumentType.integer(in: 1 ... 5))

    internal static let unsatisfiableArgument: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(name: UserFacing<StrictString, Language>({ _ in
        return "unsatisfiable"
    }), syntaxDescription: UserFacing<StrictString, Language>({ _ in
        return "An argument type that always fails to parse."
    }), parse: { (_: StrictString) -> StrictString? in
        return nil
    })

    private static let informalOption = Option(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "informal"
        case .deutsch:
            return "informell"
        }
    }), description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "uses an informal greeting."
        case .deutsch:
            return "verwendet eine informelle Begrüßung."
        }
    }), type: ArgumentType.boolean)

    private static let unsatisfiableOption: Option<StrictString> = Option(name: UserFacing<StrictString, Language>({ _ in
        return "unsatisfiable"
    }), description: UserFacing<StrictString, Language>({ _ in
        return "An option that always fails to parse."
    }), type: unsatisfiableArgument)

    private static let pathOption: Option<URL> = Option(name: UserFacing<StrictString, Language>({ _ in
        return "path"
    }), description: UserFacing<StrictString, Language>({ _ in
        return "A directory to run in."
    }), type: ArgumentType.path)

    private static let hiddenOption = Option(name: UserFacing<StrictString, Language>({ _ in "hidden" }), description: UserFacing<StrictString, Language>({ _ in "" }), type: ArgumentType.boolean, hidden: true)

    static let command = Command(name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "execute"
        case .deutsch:
            return "ausführen"
        }
    }), description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "demonstrates successful execution."
        case .deutsch:
            return "führt eine erfolgreiche Ausführung vor."
        }
    }), discussion: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
            return "There are several options."
        case .deutsch:
            return "Es gibt ein paar Optionen."
        }
    }), directArguments: [], options: [
        Execute.textOption,
        Execute.iterationsOption,
        Execute.unsatisfiableOption,
        Execute.informalOption,
        Execute.colourOption,
        Execute.pathOption,
        Execute.hiddenOption
        ], execution: { (_, options: Options, output: Command.Output) throws -> Void in

            try FileManager.default.do(in: options.value(for: Execute.pathOption) ?? URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) {

                for _ in 1 ... (options.value(for: Execute.iterationsOption) ?? 1) {

                    if let text = options.value(for: Execute.textOption) {
                        if let colour = options.value(for: Execute.colourOption) {
                            output.print(text.in(colour))
                        } else {
                            output.print(text)
                        }
                    } else {
                        let greeting: UserFacing<StrictString, Language>
                        if options.value(for: Execute.informalOption) {
                            greeting = UserFacing<StrictString, Language>({ localization in
                                switch localization {
                                case .english, .unsupported:
                                    return "Hi!"
                                case .deutsch:
                                    return "Tag!"
                                }
                            })
                        } else {
                            greeting = UserFacing<StrictString, Language>({ localization in
                                switch localization {
                                case .english, .unsupported:
                                    return "Hello, world!"
                                case .deutsch:
                                    return "Guten Tag, Welt!"
                                }
                            })
                        }
                        if let colour = options.value(for: Execute.colourOption) {
                            output.print(greeting.resolved().in(colour))
                        } else {
                            output.print(greeting.resolved())
                        }
                    }
                }
            }
    })
}
