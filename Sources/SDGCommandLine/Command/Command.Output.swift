/*
 Command.Output.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension Command {

    /// The output stream for standard output.
    public class Output {

        // MARK: - Static Properties

        /// Whether or not test mode is engaged.
        ///
        /// In test mode, command output is withheld from the terminal to make test results easier to read.
        public static var testMode: Bool = false

        // MARK: - Initialization

        internal init() {
            internalOutput = ""
        }

        // MARK: - Properties

        internal var filterFormatting = false

        public static let _newline: StrictString = "\n"
        private var internalOutput: StrictString
        internal var output: StrictString {
            var result = internalOutput
            if result.hasSuffix(Output._newline) {
                result.scalars.removeLast()
            }
            return result
        }

        /// Prints a message to the standard output.
        public func print(_ message: StrictString, terminator: StrictString = Output._newline) {
            var mutable = message + terminator

            if filterFormatting {
                mutable.removeCommandLineFormatting()
            }

            internalOutput.append(contentsOf: mutable)
            if ¬Output.testMode {
                Swift.print(mutable, terminator: "") // @exempt(from: tests)
            }
        }

        /// Prints a message to the standard output.
        public func print(_ message: String, terminator: StrictString = Output._newline) {
            print(StrictString(message), terminator: terminator)
        }
    }
}
