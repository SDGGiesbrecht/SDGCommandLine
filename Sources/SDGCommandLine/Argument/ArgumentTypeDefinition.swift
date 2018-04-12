/*
 ArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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
    public init<L1 : InputLocalization, L2 : InputLocalization>(name: UserFacingText<L1>, syntaxDescription: UserFacingText<L2>, parse: @escaping (_ argument: StrictString) -> Type?) {

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
    public func _parse(argument: StrictString) -> Any? {
        return parse(argument)
    }

    /// :nodoc:
    public func _identifier() -> StrictString {
        return key
    }

    /// :nodoc:
    public func _localizedName() -> StrictString {
        return localizedName()
    }

    /// :nodoc:
    public func _localizedDescription() -> StrictString {
        return localizedDescription()
    }
}
