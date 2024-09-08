/*
 DecodedCommandInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2022–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

internal protocol DecodedCommandInterface {
  var identifier: StrictString { get }
  var name: StrictString { get }
  var description: StrictString { get }
  var discussion: StrictString? { get }
  var subcommands: [CommandInterface] { get }
  var arguments: [ArgumentInterface] { get }
  var infiniteFinalArgument: Bool { get }
  var options: [OptionInterface] { get }
}
