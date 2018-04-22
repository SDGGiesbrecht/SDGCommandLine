/*
 Fail.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

enum Fail {

    static let command = Command(name: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "fail"
        case .deutsch:
            return "fehlschlagen"
        }
    }), description: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "demonstrates a failure."
        case .deutsch:
            return "führt einen Fehlschlag vor."
        }
    }), directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in
        output.print(UserFacingText({ (localization: Language) -> StrictString in
            switch localization {
            case .english, .unsupported:
                return "Trying..."
            case .deutsch:
                return "Versucht..."
            }
        }).resolved())
        throw Fail.error
    })

    static let error = Command.Error(description: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "Not possible."
        case .deutsch:
            return "Nicht möglich."
        }
    }), exitCode: 1)
}
