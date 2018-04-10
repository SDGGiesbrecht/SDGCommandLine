/*
 Fail.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
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
    }), directArguments: [], options: [], execution: { _, _, _  throws -> Void in
        throw Fail.error
    })

    static let error = Command.Error(description: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "I cannot do that."
        case .deutsch:
            return "Das kann ich nicht machen."
        }
    }), exitCode: 1)
}
