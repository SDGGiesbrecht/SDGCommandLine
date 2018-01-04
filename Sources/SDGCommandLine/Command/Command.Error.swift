/*
 Command.Error.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Command {

    /// A command line failure.
    public struct Error : Swift.Error {

        // MARK: - Static Properties

        internal static let successCode = 0
        internal static let generalErrorCode = Int.max

        // MARK: - Initialization

        /// Creates a command line failure.
        ///
        /// - Parameters:
        ///     - exitCode: An optional specific exit code. (If not specified, the exit code will simply be all ones.)
        ///
        /// - Precondition: `exitCode` ≠ 0
        public init<L>(description: UserFacingText<L, Void>, exitCode: Int = Int.max) {

            self.describeClosure = { description.resolved() }

            assert(exitCode ≠ Error.successCode, UserFacingText({ (localization: APILocalization, _: Void) -> StrictString in
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_]
                    return StrictString("\(Error.successCode.inDigits()) is invalid as a failing exit code.")
                }
            }))
            self.exitCode = exitCode
        }

        // MARK: - Properties

        /// The exit code.
        public let exitCode: Int

        // MARK: - Output

        private let describeClosure: () -> StrictString
        /// Returns a description of the error.
        public func describe() -> StrictString {
            return describeClosure()
        }
    }
}
