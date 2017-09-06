/*
 ArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// An argument type definition.
///
/// For standard definitions provided by SDGCommandLine, see `ArgumentType`.
public struct ArgumentTypeDefinition<Type> : AnyArgumentTypeDefinition {

    // MARK: - Initialization

    /// Creates an argument type.
    ///
    /// - Parameters:
    ///     - name: The name of the type.
    ///     - syntaxDescription: A description of the argument syntax. (Printed by the `help` subcommand.)
    ///     - parse: A closure that parses an argument and returns its value. The closure should return `nil` if the argument is invalid.
    public init<L1 : InputLocalization, L2 : InputLocalization>(name: UserFacingText<L1, Void>, syntaxDescription: UserFacingText<L2, Void>, parse: @escaping (_ argument: StrictString) -> Type?) {

        key = name.resolved(for: L1.fallbackLocalization)
        localizedName = { return name.resolved() }
        localizedDescription = { return syntaxDescription.resolved() }
        self.parse = parse
    }

    // MARK: - Properties

    internal let key: StrictString
    internal let localizedName: () -> StrictString
    internal let localizedDescription: () -> StrictString

    internal let parse: (_ argument: StrictString) -> Type?

    // MARK: - AnyArgumentTypeDefinition

    /// :nodoc:
    public func parse(argument: StrictString) -> Any? {
        return parse(argument)
    }

    /// :nodoc:
    public func getLocalizedName() -> StrictString {
        return localizedName()
    }
}
