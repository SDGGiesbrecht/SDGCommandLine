/*
 Tool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

public enum Tool {

  public static let command = createCommand()

  public static func createCommand() -> Command {
    return Command(
      name: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
          return "tool"
        case .deutsch:
          return "werkzeug"
        }
      }),
      description: UserFacing<StrictString, Language>({ localization in
        switch localization {
        case .english, .unsupported:
          return "serves as an example tool."
        case .deutsch:
          return "dient als Beilspielswerkzeug."
        }
      }),
      subcommands: [
        Execute.command, Fail.command, DemonstrateTextFormatting.command, RejectArgument.command
      ]
    )
  }
}
