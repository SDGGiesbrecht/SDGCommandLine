/*
 XCTestManifests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

extension APITests {
    static let __allTests = [
        ("testCommand", testCommand),
        ("testDirectArgument", testDirectArgument),
        ("testEnumerationOption", testEnumerationOption),
        ("testFormatting", testFormatting),
        ("testHelp", testHelp),
        ("testLanguage", testLanguage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testLocalizations", testLocalizations),
        ("testNoColour", testNoColour),
        ("testOption", testOption),
        ("testVersion", testVersion)
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testSetLanguage", testSetLanguage),
        ("testVersionSelection", testVersionSelection),
        ("testVersionSubcommand", testVersionSubcommand)
    ]
}

extension ReadMeExampleTests {
    static let __allTests = [
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testParrot", testParrot)
    ]
}

#if !os(macOS)
// MARK: - #if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests),
        testCase(ReadMeExampleTests.__allTests)
    ]
}
#endif
