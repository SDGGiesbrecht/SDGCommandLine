/*
 CommandInterface.Version2.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2022–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

extension CommandInterface {

  internal struct Version2: Decodable, DecodedCommandInterface {
    internal let identifier: StrictString
    internal let name: StrictString
    internal let description: StrictString
    internal let discussion: StrictString?
    internal let subcommands: [CommandInterface]
    internal let arguments: [ArgumentInterface]
    internal let infiniteFinalArgument: Bool
    internal let options: [OptionInterface]
  }
}
