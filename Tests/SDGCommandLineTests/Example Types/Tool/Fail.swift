/*
 Fail.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

internal struct Fail {

    internal static let command = Command(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english:
            return "fail"
        case .deutsch:
            return "fehlschlagen"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english:
            return "demonstrates a failure."
        case .deutsch:
            return "führt einen Fehlschlag vor."
        }
    }), execution: { (_) throws -> Void in
        throw Fail.error
    })

    internal static let error = Command.Error(description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english:
            return "I cannot do that."
        case .deutsch:
            return "Das kann ich nicht machen."
        }
    }), exitCode: 1)
}
