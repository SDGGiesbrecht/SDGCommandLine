/*
 AnyArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

/// A type‐erased argument definition.
public protocol AnyArgumentTypeDefinition : TextualPlaygroundDisplay {

    /// :nodoc:
    func _parse(argument: StrictString) -> Any?

    /// :nodoc:
    func _identifier() -> StrictString

    /// :nodoc:
    func _localizedName() -> StrictString

    /// :nodoc:
    func _localizedDescription() -> StrictString

    /// :nodoc:
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

    // #workaround(SDGCornerstone 0.10.1, Detatched until available again.)
    // @documentation(SDGCornerstone.CustomStringConvertible.description)
    /// A textual representation of the instance.
    public var description: String {
        return String(localizedName())
    }
}
