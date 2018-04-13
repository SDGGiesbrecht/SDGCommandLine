/*
 Command.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGPersistenceTestUtilities

/// Tests a type’s conformance to CustomStringConvertible.
///
/// This function will write the description to the test specification directory in the project repository and will compare against it on future calls. It is recommeded to check those specifications into source control to monitor changes in the description.
///
/// To update the specification instead of testing against it, change `overwriteSpecificationInsteadOfFailing` to `true` and re‐run the test suite. The specification will be rewritten to match the descriptions. *Do not forget to change it back afterward, or the test will cease to validate anything.*
///
/// Parameters:
///     - instance: An instance to get a description from.
///     - localizations: The localization set to test.
///     - uniqueTestName: A unique name for the test. This is used in the path to the persistent test specifications.
///     - overwriteSpecificationInsteadOfFailing: Set to `false` for normal behaviour. Set to `true` temporarily to update the specification.
@_inlineable public func testCommand<L>(_ command: Command, with arguments: [StrictString], in workingDirectory: URL? = nil, localizations: L.Type, uniqueTestName: StrictString, overwriteSpecificationInsteadOfFailing: Bool, file: StaticString = #file, line: UInt = #line) where L : InputLocalization {

    for localization in localizations.cases {
        autoreleasepool {

            let filename: String
            if let icon = localization.icon {
                filename = String(icon)
            } else {
                filename = localization.code
            }

            let specification = testSpecificationDirectory(file).appendingPathComponent("Command").appendingPathComponent(String(uniqueTestName)).appendingPathComponent(filename + ".txt")

            LocalizationSetting(orderOfPrecedence: [localization.code]).do {

                var report = ""
                print("$ " + ([command.localizedName()] + arguments).joined(separator: " "), to: &report)

                do {
                    if let location = workingDirectory {
                        try FileManager.default.do(in: location) {
                            print(try command.execute(with: arguments), to: &report)
                        }
                    }
                    print(try command.execute(with: arguments), to: &report)

                    print(Command.Error.successCode, to: &report)
                } catch let error as Command.Error {
                    // [_Warning: This needs fixing._]
                    print(error.describe(), to: &report)
                    print(error.exitCode, to: &report)
                } catch {
                    print(error.localizedDescription, to: &report)
                    print(Command.Error.generalErrorCode, to: &report)
                }

                SDGPersistenceTestUtilities.compare(report, against: specification, overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing, file: file, line: line)
            }
        }
    }
}
