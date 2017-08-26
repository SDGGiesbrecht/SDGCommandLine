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

    private static let unsatisfiableArgument: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(name: UserFacingText({ (_: Language, _: Void) -> StrictString in
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
    }), options: [
        Execute.textOption,
        Execute.unsatisfiableOption,
        Execute.informalOption
        ], execution: { (options: Options, output: inout Command.Output) throws -> Void in

            if let text = options.value(for: Execute.textOption) {
                print(text, to: &output)
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
                print(greeting.resolved(), to: &output)
            }
    })
}
