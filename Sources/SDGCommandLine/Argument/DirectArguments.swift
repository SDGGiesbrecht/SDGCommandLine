/*
 DirectArguments.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// Parsed direct (ordered) arguments.
///
/// - SeeAlso: `Options`
public struct DirectArguments {

    // MARK: - Initialization

    internal init() {

    }

    // MARK: - Properties

    private var arguments: [Any] = []

    // MARK: - Usage

    internal mutating func add(value: Any) {
        arguments.append(value)
    }

    /// Returns the value of the specified argument, or `nil` if the argument is not defined.
    public func argument<T>(at index: Int, as type: ArgumentTypeDefinition<T>) -> T? {
        guard index ∈ arguments.bounds else {
            return nil
        }
        return arguments[index] as? T
    }
}
