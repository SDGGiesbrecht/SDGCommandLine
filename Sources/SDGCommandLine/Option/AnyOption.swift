/*
 AnyOption.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

import SDGText

/// A type‐erased option.
public protocol AnyOption: Sendable, TextualPlaygroundDisplay {

  var _identifier: StrictString { get }
  var _isHidden: Bool { get }

  func _matches(name: StrictString) -> Bool
  func _localizedName() -> StrictString
  func _localizedDescription() -> StrictString
  func _type() -> AnyArgumentTypeDefinition
  func _interface() -> _OptionInterface
}

extension AnyOption {

  internal var identifier: StrictString {
    return _identifier
  }

  internal var isHidden: Bool {
    return _isHidden
  }

  internal func matches(name: StrictString) -> Bool {
    return _matches(name: name)
  }

  internal func localizedName() -> StrictString {
    return _localizedName()
  }

  internal func localizedDescription() -> StrictString {
    return _localizedDescription()
  }

  internal func type() -> AnyArgumentTypeDefinition {
    return _type()
  }

  internal func interface() -> _OptionInterface {
    return _interface()
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    return String(localizedName())
  }
}
