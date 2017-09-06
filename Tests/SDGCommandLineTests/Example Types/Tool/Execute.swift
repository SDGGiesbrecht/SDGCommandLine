/*
 Execute.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct Execute {

    private static let textOption = Option(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "string"
        case .deutsch:
            return "zeichenkette"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "Text to display."
        case .deutsch:
            return "Text zum Zeigen."
        }
    }), type: ArgumentType.string)

    private static let colourArgumentType = ArgumentType.enumeration(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "colour"
        case .deutsch:
            return "farbe"
        }
    }), cases: [
        (Colour.red, UserFacingText({ (localization: Language, _: Void) -> StrictString in
            switch localization {
            case .english, .unsupported:
                return "red"
            case .deutsch:
                return "rot"
            }
        })),
        (Colour.green, UserFacingText({ (localization: Language, _: Void) -> StrictString in
            switch localization {
            case .english, .unsupported:
                return "green"
            case .deutsch:
                return "grün"
            }
        })),
        (Colour.blue, UserFacingText({ (localization: Language, _: Void) -> StrictString in
            switch localization {
            case .english, .unsupported:
                return "blue"
            case .deutsch:
                return "blau"
            }
        }))
        ])

    private static let colourOption = Option(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "colour"
        case .deutsch:
            return "Farbe"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "A colour for the text."
        case .deutsch:
            return "Eine Farbe für den Text."
        }
    }), type: Execute.colourArgumentType)

    internal static let unsatisfiableArgument: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(name: UserFacingText({ (_: Language, _: Void) -> StrictString in
        return "unsatisfiable"
    }), syntaxDescription: UserFacingText({ (_: Language, _: Void) -> StrictString in
        return "An argument type that always fails to parse."
    }), parse: { (_: StrictString) -> StrictString? in
        return nil
    })

    private static let informalOption = Option(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "informal"
        case .deutsch:
            return "informell"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "uses an informal greeting."
        case .deutsch:
            return "verwendet eine informelle Begrüßung."
        }
    }), type: ArgumentType.boolean)

    private static let unsatisfiableOption: Option<StrictString> = Option(name: UserFacingText({ (_: Language, _: Void) -> StrictString in
        return "unsatisfiable"
    }), description: UserFacingText({ (_: Language, _: Void) -> StrictString in
        return "An option that always fails to parse."
    }), type: unsatisfiableArgument)

    static let command = Command(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "execute"
        case .deutsch:
            return "ausführen"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "demonstrates successful execution."
        case .deutsch:
            return "führt eine erfolgreiche Ausführung vor."
        }
    }), directArguments: [], options: [
        Execute.textOption,
        Execute.unsatisfiableOption,
        Execute.informalOption,
        Execute.colourOption
        ], execution: { (_, options: Options, output: inout Command.Output) throws -> Void in

            if let text = options.value(for: Execute.textOption) {
                if let colour = options.value(for: Execute.colourOption) {
                    print(text.in(colour), to: &output)
                } else {
                    print(text, to: &output)
                }
            } else {
                let greeting: UserFacingText<Language, Void>
                if options.value(for: Execute.informalOption) {
                    greeting = UserFacingText({ (localization: Language, _: Void) -> StrictString in
                        switch localization {
                        case .english, .unsupported:
                            return "Hi!"
                        case .deutsch:
                            return "Tag!"
                        }
                    })
                } else {
                    greeting = UserFacingText({ (localization: Language, _: Void) -> StrictString in
                        switch localization {
                        case .english, .unsupported:
                            return "Hello, world!"
                        case .deutsch:
                            return "Guten Tag, Welt!"
                        }
                    })
                }
                if let colour = options.value(for: Execute.colourOption) {
                    print(greeting.resolved().in(colour), to: &output)
                } else {
                    print(greeting.resolved(), to: &output)
                }
            }
    })
}
