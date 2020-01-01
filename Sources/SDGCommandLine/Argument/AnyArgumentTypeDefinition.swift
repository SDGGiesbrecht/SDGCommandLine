/*
 AnyArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGText

/// A type‐erased argument definition.
public protocol AnyArgumentTypeDefinition: TextualPlaygroundDisplay {
  func _parse(argument: StrictString) -> Any?
  func _identifier() -> StrictString
  func _localizedName() -> StrictString
  func _localizedDescription() -> StrictString
  func _interface() -> _ArgumentInterface
}

extension AnyArgumentTypeDefinition {

  internal func parse(argument: StrictString) -> Any? {
    return _parse(argument: argument)
  }

  internal func identifier() -> StrictString {
    return _identifier()
  }

  internal func localizedName() -> StrictString {
    return _localizedName()
  }

  internal func localizedDescription() -> StrictString {
    return _localizedDescription()
  }

  internal func interface() -> _ArgumentInterface {
    return _interface()
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    return String(localizedName())
  }
}
