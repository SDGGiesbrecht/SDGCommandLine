/*
 AnyOption.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A type‐erased option.
public protocol AnyOption {

    /// :nodoc:
    var _uniqueKey: StrictString { get }

    /// :nodoc:
    func _matches(name: StrictString) -> Bool

    /// :nodoc:
    func _localizedName() -> StrictString

    /// :nodoc:
    func _localizedDescription() -> StrictString

    /// :nodoc:
    func _type() -> AnyArgumentTypeDefinition
}

extension AnyOption {

    internal var uniqueKey: StrictString {
        return _uniqueKey
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
}
