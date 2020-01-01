/*
 OptionInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

import SDGCommandLine

/// An option.
public struct OptionInterface: Decodable {

  /// A unique identifier that can be compared across localizations to find corresponding options.
  public var identifier: StrictString

  /// The name.
  public var name: StrictString

  /// The description.
  public var description: StrictString

  /// The type.
  public var type: ArgumentInterface

  /// Whether or not the option is a Boolean flag.
  public var isFlag: Bool {
    return type.identifier == ArgumentType.boolean._identifier()
  }
}
