/*
 Command.Output.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Command {

    /// The output stream for standard output.
    public struct Output : TextOutputStream {

        // MARK: - Initialization

        internal init() {
            internalOutput = ""
        }

        // MARK: - Properties

        private static let newLine: StrictString = "\n"
        private var internalOutput: StrictString
        internal var output: StrictString {
            var result = internalOutput
            if result.hasSuffix(Output.newLine) {
                result.scalars.removeLast()
            }
            return result
        }

        // MARK: - TextOutputStream

        // [_Inherit Documentation: SDGCornerstone.TextOutputStream.write(_:)_]
        /// Appends the given string to the stream.
        public mutating func write(_ string: String) {
            let strict = StrictString(string)
            internalOutput.append(contentsOf: strict)
            print(strict, terminator: "")
        }
    }
}
