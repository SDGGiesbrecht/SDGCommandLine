/*
 DemonstrateRepeatedArgument.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

internal enum DemonstrateRepeatedArgument {

  internal static let command = Command(
    name: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrate‐repeated‐argument"
      case .deutsch:
        return "wiederholtes‐argument‐vorführen"
      }
    }),
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrates a repeated argument."
      case .deutsch:
        return "führt ein wiederholtes Argument vor."
      }
    }),
    directArguments: [ArgumentType.string, ArgumentType.integer(in: 1...10)],
    infiniteFinalArgument: true,
    options: [],
    execution: { (arguments, _, output) throws -> Void in
      _ = arguments.argument(at: 0, as: ArgumentType.string)
      for integer in arguments.arguments(from: 1, as: ArgumentType.integer(in: 1...10)) {
        output.print(integer.inDigits())
      }
    }
  )
}
