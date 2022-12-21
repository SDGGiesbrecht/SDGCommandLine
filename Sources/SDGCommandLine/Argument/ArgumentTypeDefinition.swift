/*
 ArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

/// An argument type definition.
///
/// For standard definitions provided by SDGCommandLine, see `ArgumentType`.
public struct ArgumentTypeDefinition<Type>: AnyArgumentTypeDefinition
where Type: Sendable {

  // MARK: - Initialization

  /// Creates an argument type.
  ///
  /// - Parameters:
  ///     - name: The name of the type.
  ///     - syntaxDescription: A description of the argument syntax. (Printed by the `help` subcommand.)
  ///     - parse: A closure that parses an argument and returns its value. The closure should return `nil` if the argument is invalid.
  public init<N: InputLocalization, D: Localization>(
    name: UserFacing<StrictString, N>,
    syntaxDescription: UserFacing<StrictString, D>,
    parse: @Sendable @escaping (_ argument: StrictString) -> Type?
  ) {

    identifier = name.resolved(for: N.fallbackLocalization)
    let sendableName: @Sendable () -> StrictString = { name.resolved() }
    localizedName = sendableName
    let sendableDescription: @Sendable () -> StrictString = { syntaxDescription.resolved() }
    localizedDescription = sendableDescription
    self.parse = parse
  }

  // MARK: - Properties

  internal let identifier: StrictString
  internal let localizedName: @Sendable () -> StrictString
  internal let localizedDescription: @Sendable () -> StrictString

  internal let parse: @Sendable (_ argument: StrictString) -> Type?

  // MARK: - AnyArgumentTypeDefinition

  public func _parse(argument: StrictString) -> Sendable? {
    return parse(argument)
  }

  public func _identifier() -> StrictString {
    return identifier
  }

  public func _localizedName() -> StrictString {
    return localizedName()
  }

  public func _localizedDescription() -> StrictString {
    return localizedDescription()
  }

  public func _interface() -> _ArgumentInterface {
    return _ArgumentInterface(
      identifier: identifier,
      name: localizedName(),
      description: identifier == ArgumentType.booleanIdentifier ? "" : localizedDescription()
    )
  }
}
