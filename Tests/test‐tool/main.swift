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

ProcessInfo.applicationIdentifier = "ca.solideogloria.SDGCommandLine.test‐tool"
ProcessInfo.version = nil
ProcessInfo.packageURL = nil

enum Language : String, CaseIterable, InputLocalization {
    case englishCanada = "en\u{2D}CA"
    static let fallbackLocalization: Language = .englishCanada
}

let execute = Command(name: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "execute"
    }
}), description: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "demonstrates successful execution."
    }
}), directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in
    output.print(UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .englishCanada:
            return "Hello, world!"
        }
    }).resolved())
})

let fail = Command(name: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "fail"
    }
}), description: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "demonstrates a failure."
    }
}), directArguments: [], options: [], execution: { (_, _, _) throws -> Void in
    try execute.execute(with: [])
    throw Command.Error(description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .englishCanada:
            return "Something failed."
        }
    }))
})

Command(name: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "test‐tool"
    }
}), description: UserFacing<StrictString, Language>({ localization in
    switch localization {
    case .englishCanada:
        return "serves as an example tool."
    }
}), subcommands: [execute, fail]).executeAsMain()
