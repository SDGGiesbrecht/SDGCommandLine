/*
 Option.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

/// A command line option.
public struct Option<Type> : AnyOption {

    // MARK: - Static Properties

    internal static var optionMarkers: [StrictString] {
        return [
            "•",
            "\u{2D}\u{2D}"
        ]
    }

    // MARK: - Initialization

    /// Creates a command line option.
    ///
    /// - Parameters:
    ///     - name: The name. (Without the leading option marker.)
    ///     - description: A brief description. (Printed by the `help` subcommand.)
    ///     - type: An `ArgumentTypeDefinition` representing the type of the argument.
    public init<N : InputLocalization, D : Localization>(name: UserFacingText<N>, description: UserFacingText<D>, type: ArgumentTypeDefinition<Type>) {

        key = name.resolved(for: N.fallbackLocalization)
        names = Command.list(names: name)
        localizedName = { return Command.normalizeToUnicode(name.resolved(), in: LocalizationSetting.current.value.resolved() as N) }
        localizedDescription = { return description.resolved() }
        self.type = type
    }

    // MARK: - Properties

    internal let key: StrictString
    private let names: Set<StrictString>
    private let localizedName: () -> StrictString
    private let localizedDescription: () -> StrictString

    private let type: ArgumentTypeDefinition<Type>

    // MARK: - AnyOption

    /// :nodoc:
    public var _uniqueKey: StrictString {
        return key
    }

    /// :nodoc:
    public func _matches(name: StrictString) -> Bool {
        return name ∈ names
    }

    /// :nodoc:
    public func _localizedName() -> StrictString {
        return localizedName()
    }

    /// :nodoc:
    public func _localizedDescription() -> StrictString {
        return localizedDescription()
    }

    /// :nodoc:
    public func _type() -> AnyArgumentTypeDefinition {
        return type
    }
}
