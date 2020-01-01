/*
 RejectArgument.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

enum RejectArgument {

  static let command = Command(
    name: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "reject‐argument"
      case .deutsch:
        return "argument‐ablehnen"
      }
    }),
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrates rejection of an argument."
      case .deutsch:
        return "führt die Ablehnung eines Arguments vor."
      }
    }),
    directArguments: [Execute.unsatisfiableArgument],
    options: [],
    execution: { (_, _, _) throws -> Void in
    }
  )
}
