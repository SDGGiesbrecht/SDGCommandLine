/*
 AnyArgumentTypeDefinition.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A type‐erased argument definition.
public protocol AnyArgumentTypeDefinition {

    /// :nodoc:
    func parse(argument: StrictString) -> Any?

    /// :nodoc:
    func getLocalizedName() -> StrictString
}
