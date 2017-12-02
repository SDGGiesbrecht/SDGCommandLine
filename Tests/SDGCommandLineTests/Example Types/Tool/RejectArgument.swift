/*
 RejectArgument.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

enum RejectArgument {

    static let command = Command(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "reject‐argument"
        case .deutsch:
            return "argument‐ablehnen"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "demonstrates rejection of an argument."
        case .deutsch:
            return "führt die Ablehnung eines Arguments vor."
        }
    }), directArguments: [Execute.unsatisfiableArgument], options: [], execution: { (_, _, _) throws -> Void in
    })
}
