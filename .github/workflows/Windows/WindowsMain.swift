/*
 WindowsMain.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

@testable import SDGExportedCommandLineInterfaceTests
@testable import SDGCommandLineTests

extension SDGExportedCommandLineInterfaceTests.SDGExportedCommandLineInterfaceAPITests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testCommandInterface", testCommandInterface),
    ])
  ]
}

extension SDGCommandLineTests.SDGCommandLineAPITests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testArgumentType", testArgumentType),
      ("testCommand", testCommand),
      ("testCommandError", testCommandError),
      ("testDirectArgument", testDirectArgument),
      ("testEnumerationOption", testEnumerationOption),
      ("testFormatting", testFormatting),
      ("testHelp", testHelp),
      ("testLanguage", testLanguage),
      ("testLocalizations", testLocalizations),
      ("testNoColour", testNoColour),
      ("testOption", testOption),
      ("testVersion", testVersion),
    ])
  ]
}

extension SDGCommandLineTests.ReadMeExampleTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testParrot", testParrot),
    ])
  ]
}

extension SDGCommandLineTests.InternalTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testDirectArguments", testDirectArguments),
      ("testEmptyCache", testEmptyCache),
      ("testExportInterface", testExportInterface),
      ("testSetLanguage", testSetLanguage),
      ("testOptions", testOptions),
      ("testVersionSelection", testVersionSelection),
      ("testVersionSubcommand", testVersionSubcommand),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += SDGExportedCommandLineInterfaceTests.SDGExportedCommandLineInterfaceAPITests.windowsTests
tests += SDGCommandLineTests.SDGCommandLineAPITests.windowsTests
tests += SDGCommandLineTests.ReadMeExampleTests.windowsTests
tests += SDGCommandLineTests.InternalTests.windowsTests

XCTMain(tests)
