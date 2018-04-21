/*
 main.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

initialize(applicationIdentifier: "ca.solideogloria.SDGCommandLine.test‐tool", version: nil, packageURL: nil)

enum Language : String, InputLocalization {
    case englishCanada = "en\u{2D}CA"
    static let cases: [Language] = [.englishCanada]
    static let fallbackLocalization: Language = .englishCanada
}

let execute = Command(name: UserFacingText<Language>({ localization in
    switch localization {
    case .englishCanada:
        return "execute"
    }
}), description: UserFacingText({ (localization: Language) -> StrictString in
    switch localization {
    case .englishCanada:
        return "demonstrates successful execution."
    }
}), directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in
    output.print(UserFacingText<Language>({ localization in
        switch localization {
        case .englishCanada:
            return "Hello, world!"
        }
    }).resolved())
})

let fail = Command(name: UserFacingText<Language>({ localization in
    switch localization {
    case .englishCanada:
        return "fail"
    }
}), description: UserFacingText({ (localization: Language) -> StrictString in
    switch localization {
    case .englishCanada:
        return "demonstrates a failure."
    }
}), directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in
    throw Command.Error(description: UserFacingText<Language>({ localization in
        switch localization {
        case .englishCanada:
            return "I cannot do that."
        }
    }))
})

Command(name: UserFacingText<Language>({ localization in
    switch localization {
    case .englishCanada:
        return "test‐tool"
    }
}), description: UserFacingText({ (localization: Language) -> StrictString in
    switch localization {
    case .englishCanada:
        return "serves as an example tool."
    }
}), subcommands: [execute, fail]).executeAsMain()
