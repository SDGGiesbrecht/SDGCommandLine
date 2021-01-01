/*
 Fail.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2021 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization

import SDGCommandLine

internal enum Fail {

  private static let systemOption = Option(
    name: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "system"
      case .deutsch:
        return "system"
      }
    }),
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "triggers a system error."
      case .deutsch:
        return "verursacht einen Systemfehler."
      }
    }),
    type: ArgumentType.boolean
  )

  internal static let command = Command(
    name: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "fail"
      case .deutsch:
        return "fehlschlagen"
      }
    }),
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrates a failure."
      case .deutsch:
        return "führt einen Fehlschlag vor."
      }
    }),
    directArguments: [],
    options: [systemOption],
    execution: { (_, options: Options, output: Command.Output) throws -> Void in
      output.print(
        UserFacing<StrictString, Language>({ localization in
          switch localization {
          case .english, .unsupported:
            return "Trying..."
          case .deutsch:
            return "Versucht..."
          }
        }).resolved()
      )
      if options.value(for: systemOption) {
        struct StandInError: PresentableError {
          func presentableDescription() -> StrictString {
            return "[...]"
          }
        }
        throw StandInError()
      }
      throw Fail.error
    }
  )

  private static let error = Command.Error(
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "Not possible."
      case .deutsch:
        return "Nicht möglich."
      }
    }),
    exitCode: 1
  )
}
