/*
 DirectArguments.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGCollections

/// Parsed direct (ordered) arguments.
///
/// - SeeAlso: `Options`
public struct DirectArguments: TransparentWrapper {

  // MARK: - Initialization

  internal init() {}

  // MARK: - Properties

  private var arguments: [Any] = []

  // MARK: - Usage

  internal mutating func add(value: Any) {
    arguments.append(value)
  }

  /// Returns the value of the specified argument, or `nil` if the argument is not defined.
  ///
  /// - Parameters:
  ///     - index: The index to check.
  ///     - type: The type to attempt to cast to.
  public func argument<T>(at index: Int, as type: ArgumentTypeDefinition<T>) -> T? {
    guard index ∈ arguments.bounds else {
      return nil
    }
    return arguments[index] as? T
  }

  /// Returns the values of all arguments from a particular index onwards.
  ///
  /// - Parameters:
  ///   - index: The first index.
  ///   - type: The type to attempt to cast to.
  public func arguments<T>(from index: Int, as type: ArgumentTypeDefinition<T>) -> [T] {
    let startIndex = min(arguments.endIndex, index)
    return (startIndex..<arguments.endIndex).compactMap { index in
      return argument(at: index, as: type)
    }
  }

  // MARK: - TransparentWrapper

  public var wrappedInstance: Any {
    return arguments
  }
}
