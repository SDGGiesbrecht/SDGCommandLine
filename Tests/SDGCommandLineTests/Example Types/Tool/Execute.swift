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

internal struct Execute {

    internal static let command = Command(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english:
            return "execute"
        case .deutsch:
            return "ausführen"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english:
            return "demonstrates successful execution."
        case .deutsch:
            return "führt eine erfolgreiche Ausführung vor."
        }
    }), execution: { (output: inout Command.Output) throws -> Void in
        let greeting = UserFacingText({ (localization: Language, _: Void) -> StrictString in
            switch localization {
            case .english:
                return "Hello, world!"
            case .deutsch:
                return "Guten Tag, Welt!"
            }
        })
        print(greeting.resolved(), to: &output)
    })
}
