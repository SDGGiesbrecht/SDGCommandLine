/*
 Tool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct Tool {

    static let command = Command(name: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "tool"
        case .deutsch:
            return "werkzeug"
        }
    }), description: UserFacingText({ (localization: Language, _: Void) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "serves as an example tool."
        case .deutsch:
            return "dient als Beilspielswerkzeug."
        }
    }), subcommands: [Execute.command, Fail.command, DemonstrateTextFormatting.command])
}
