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
    var uniqueKey: StrictString { get }

    /// :nodoc:
    func matches(name: StrictString) -> Bool

    /// :nodoc:
    func parse(argument: StrictString) -> Any?

    /// :nodoc:
    func getLocalizedName() -> StrictString

    /// :nodoc:
    func getLocalizedDescription() -> StrictString

    /// :nodoc:
    func getTypeIdentifier() -> StrictString

    /// :nodoc:
    func getLocalizedType() -> StrictString

    /// :nodoc:
    func getLocalizedTypeDescription() -> StrictString
}
