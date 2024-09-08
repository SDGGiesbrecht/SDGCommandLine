/*
 Command.Error.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLineLocalizations

extension Command {

  /// A command line failure.
  public struct Error: PresentableError, Sendable {

    // MARK: - Static Properties

    /// The exit code indicating success.
    public static let successCode: Int = 0
    /// The default exit code for an inspecific failure.
    public static let generalErrorCode: Int = Int.max

    // MARK: - Initialization

    /// Creates a command line failure.
    ///
    /// - Precondition: `exitCode` ≠ 0
    ///
    /// - Parameters:
    ///     - description: A description of the error.
    ///     - exitCode: An optional specific exit code. (If not specified, the exit code will simply be all ones.)
    public init<L>(description: UserFacing<StrictString, L>, exitCode: Int = Int.max) {

      self.describeClosure = { description.resolved() }

      assert(
        exitCode ≠ Error.successCode,
        UserFacing<StrictString, APILocalization>({ localization in  // @exempt(from: tests)
          switch localization {  // @exempt(from: tests)
          case .englishCanada:
            return "\(Error.successCode.inDigits()) is invalid as a failing exit code."
          }
        })
      )
      self.exitCode = exitCode

      self.underlyingError = nil
    }

    internal init(wrapping error: Swift.Error) {
      self.describeClosure = { StrictString(error.localizedDescription) }
      self.exitCode = Error.generalErrorCode
      self.underlyingError = error
    }

    // MARK: - Properties

    /// The exit code.
    public let exitCode: Int

    /// The output up until the error occurred.
    ///
    /// This will be automatically added when rethrown by `Command.executable(with:)`. If the error is intercepted sooner, this property will still be `nil`.
    public internal(set) var output: StrictString?

    /// The underlying error.
    ///
    /// This will contain the underlying error if `Command.executable(with:)` caught a different error type and wrapped it in a `Command.Error` instance to provide the output and exit code.
    public let underlyingError: Swift.Error?

    // MARK: - Output

    private let describeClosure: @Sendable () -> StrictString

    // MARK: - PresentableError

    public func presentableDescription() -> StrictString {
      return describeClosure()
    }
  }
}
