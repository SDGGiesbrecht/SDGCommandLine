/*
 Option.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import SDGText
import SDGLocalization

/// A command line option.
public struct Option<Type>: AnyOption where Type: Sendable {

  // MARK: - Static Properties

  internal static var optionMarkers: [StrictString] {
    return [
      "•",
      "\u{2D}\u{2D}",
    ]
  }

  // MARK: - Initialization

  /// Creates a command line option.
  ///
  /// - Parameters:
  ///     - name: The name. (Without the leading option marker.)
  ///     - description: A brief description. (Printed by the `help` subcommand.)
  ///     - type: An `ArgumentTypeDefinition` representing the type of the argument.
  ///     - hidden: Optional. Set to `true` to hide the option from the “help” lists.
  public init<N: InputLocalization, D: Localization>(
    name: UserFacing<StrictString, N>,
    description: UserFacing<StrictString, D>,
    type: ArgumentTypeDefinition<Type>,
    hidden: Bool = false
  ) {

    identifier = name.resolved(for: N.fallbackLocalization)
    names = Command.list(names: name)
    let sendableName: @Sendable () -> StrictString = {
      return Command.normalizeToUnicode(
        name.resolved(),
        in: LocalizationSetting.current.value.resolved() as N
      )
    }
    localizedName = sendableName
    let sendableDescription: @Sendable () -> StrictString = { description.resolved() }
    localizedDescription = sendableDescription
    self.type = type
    self.isHidden = hidden
  }

  // MARK: - Properties

  internal let identifier: StrictString
  private let names: Set<StrictString>
  private let localizedName: @Sendable () -> StrictString
  private let localizedDescription: @Sendable () -> StrictString
  private let isHidden: Bool

  private let type: ArgumentTypeDefinition<Type>

  // MARK: - AnyOption

  public var _identifier: StrictString {
    return identifier
  }

  public var _isHidden: Bool {
    return isHidden
  }

  public func _matches(name: StrictString) -> Bool {
    return name ∈ names
  }

  public func _localizedName() -> StrictString {
    return localizedName()
  }

  public func _localizedDescription() -> StrictString {
    return localizedDescription()
  }

  public func _type() -> AnyArgumentTypeDefinition {
    return type
  }

  public func _interface() -> _OptionInterface {
    return _OptionInterface(
      identifier: identifier,
      name: localizedName(),
      description: localizedDescription(),
      type: type()._interface()
    )
  }
}
