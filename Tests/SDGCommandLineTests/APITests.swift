/*
 APITests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2023 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization
import SDGVersioning

import SDGSwift

import SDGCommandLine

import SDGCommandLineLocalizations

import XCTest

import SDGPersistenceTestUtilities
import SDGLocalizationTestUtilities

import SDGCommandLineTestUtilities
import TestTool

class APITests: TestCase {

  func testArgumentType() {
    testCustomStringConvertibleConformance(
      of: ArgumentType.string,
      localizations: InterfaceLocalization.self,
      uniqueTestName: "String",
      overwriteSpecificationInsteadOfFailing: false
    )

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•iterations", "2"],
      localizations: Language.self,
      uniqueTestName: "Integer",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•iterations", "−1"],
      localizations: Language.self,
      uniqueTestName: "Invalid Integer",
      overwriteSpecificationInsteadOfFailing: false
    )
    #if !os(Android)  // Path is read only.
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["execute", "•path", "/tmp"],
        localizations: Language.self,
        uniqueTestName: "Absolute Path",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•path", "~"],
      localizations: Language.self,
      uniqueTestName: "Home",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•path", "~/"],
      localizations: Language.self,
      uniqueTestName: "Home 2",
      overwriteSpecificationInsteadOfFailing: false
    )
    #if !os(Android)  // Path is read only.
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["execute", "•path", "~/.SDG/Test"],
        localizations: Language.self,
        uniqueTestName: "User Path",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
    #if !os(Android)  // Path is read only.
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["execute", "•path", "tmp"],
        localizations: Language.self,
        uniqueTestName: "Path",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCommand() {
    testCustomStringConvertibleConformance(
      of: Tool.rootCommand,
      localizations: InterfaceLocalization.self,
      uniqueTestName: "Tool",
      overwriteSpecificationInsteadOfFailing: false
    )

    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      FileManager.default.withTemporaryDirectory(appropriateFor: nil) { temporary in
        SDGCommandLineTestUtilities.testCommand(
          Tool.rootCommand,
          with: ["execute"],
          in: temporary,
          localizations: Language.self,
          uniqueTestName: "Execution",
          overwriteSpecificationInsteadOfFailing: false
        )
      }
    #endif

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["fail"],
      localizations: Language.self,
      uniqueTestName: "Failure",
      overwriteSpecificationInsteadOfFailing: false
    )

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["ausführen"],
      localizations: Language.self,
      uniqueTestName: "Foreign Command",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testCommandError() {
    #if os(Linux)  // System error descriptions differ.
      let result = Tool.rootCommand.execute(with: ["fail", "•system"])
      _ = result.mapError { (error: Command.Error) -> Command.Error in
        _ = error.localizedDescription
        return error
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["fail", "•system"],
        localizations: Language.self,
        uniqueTestName: "System Error",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testDirectArgument() {
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["reject‐argument", "..."],
      localizations: SystemLocalization.self,
      uniqueTestName: "Invalid Argument",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "invalid"],
      localizations: SystemLocalization.self,
      uniqueTestName: "Unexpected Argument",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["demonstrate‐repeated‐argument", "skip", "1", "2", "3"],
      localizations: SystemLocalization.self,
      uniqueTestName: "Repeated Argument",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testEnumerationOption() {
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•colour", "red"],
      localizations: Language.self,
      uniqueTestName: "Accept Enumeration",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•colour", "rot"],
      localizations: Language.self,
      uniqueTestName: "Accept Foreign Enumeration",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•colour", "none"],
      localizations: SystemLocalization.self,
      uniqueTestName: "Invalid Enumeration",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testFormatting() throws {
    let output = try Tool.rootCommand.execute(with: ["demonstrate‐text‐formatting"]).get()
    XCTAssert(output.contains("\u{1B}[1m".scalars.literal()), "Bold formatting missing.")
    XCTAssert(output.contains("\u{1B}[22m".scalars.literal()), "Bold formatting never reset.")
  }

  func testHelp() {
    #if PLATFORM_LACKS_FOUNDATION_PROCESS  // •use‐version unavailable.
      for localization in SystemLocalization.allCases {
        LocalizationSetting(orderOfPrecedence: [localization.code]).do {
          Tool.rootCommand.execute(with: ["execute", "help"])
        }
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["execute", "help"],
        localizations: SystemLocalization.self,
        uniqueTestName: "Help",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
    #if PLATFORM_LACKS_FOUNDATION_PROCESS  // •use‐version unavailable.
      for localization in SystemLocalization.allCases {
        LocalizationSetting(orderOfPrecedence: [localization.code]).do {
          Tool.rootCommand.execute(with: ["reject‐argument", "help"])
        }
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["reject‐argument", "help"],
        localizations: SystemLocalization.self,
        uniqueTestName: "Help (with Direct Arguments)",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
    #if PLATFORM_LACKS_FOUNDATION_PROCESS  // •use‐version unavailable.
      for localization in SystemLocalization.allCases {
        LocalizationSetting(orderOfPrecedence: [localization.code]).do {
          Tool.rootCommand.execute(with: ["demonstrate‐repeated‐argument", "help"])
        }
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["demonstrate‐repeated‐argument", "help"],
        localizations: SystemLocalization.self,
        uniqueTestName: "Help (with Repeated Arguments)",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testLanguage() {
    #if PLATFORM_LACKS_FOUNDATION_PROCESS  // •use‐version unavailable.
      for localization in SystemLocalization.allCases {
        LocalizationSetting(orderOfPrecedence: [localization.code]).do {
          Tool.rootCommand.execute(with: ["help", "•language", "he"])
        }
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["help", "•language", "he"],
        localizations: Language.self,
        uniqueTestName: "Language Selection by Code",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
    #if PLATFORM_LACKS_FOUNDATION_PROCESS  // •use‐version unavailable.
      for localization in SystemLocalization.allCases {
        LocalizationSetting(orderOfPrecedence: [localization.code]).do {
          Tool.rootCommand.execute(with: ["help", "•language", "🇬🇷ΕΛ"])
        }
      }
    #else
      SDGCommandLineTestUtilities.testCommand(
        Tool.rootCommand,
        with: ["help", "•language", "🇬🇷ΕΛ"],
        localizations: Language.self,
        uniqueTestName: "Language Selection by Icon",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testLocalizations() {
    XCTAssert(
      _InterfaceLocalization.codeSet() ⊆ InterfaceLocalization.codeSet(),
      "Not all interface localizations are supported by SDGCornerstone. Start by localizing it."
    )
    XCTAssert(
      _APILocalization.codeSet() ⊆ APILocalization.codeSet(),
      "Not all API localizations are supported by SDGCornerstone. Start by localizing it."
    )
  }

  func testNoColour() throws {
    let output = try Tool.rootCommand.execute(with: ["help", "•no‐colour"]).get()
    XCTAssert(¬output.contains("\u{1B}"), "Failed to disable colour.")
  }

  func testOption() {
    testCustomStringConvertibleConformance(
      of: Execute.textOption,
      localizations: InterfaceLocalization.self,
      uniqueTestName: "Text",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•string", "Changed using an option."],
      localizations: Language.self,
      uniqueTestName: "Unicode Option",
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "\u{2D}\u{2D}string", "Changed using an option."],
      localizations: Language.self,
      uniqueTestName: "ASCII Option",
      overwriteSpecificationInsteadOfFailing: false
    )

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•informal"],
      localizations: Language.self,
      uniqueTestName: "Flag",
      overwriteSpecificationInsteadOfFailing: false
    )

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•invalid"],
      localizations: SystemLocalization.self,
      uniqueTestName: "Invalid Option",
      overwriteSpecificationInsteadOfFailing: false
    )

    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•string"],
      localizations: SystemLocalization.self,
      uniqueTestName: "Missing Option Argument",
      allowColour: true,
      overwriteSpecificationInsteadOfFailing: false
    )
    SDGCommandLineTestUtilities.testCommand(
      Tool.rootCommand,
      with: ["execute", "•unsatisfiable", "..."],
      localizations: SystemLocalization.self,
      uniqueTestName: "Invalid Option Argument",
      allowColour: true,
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testVersion() {
    let version = Version(1, 2, 3)
    XCTAssertEqual(version.compatibleVersions.lowerBound, version)
    XCTAssertEqual(version.compatibleVersions.upperBound, Version(2, 0, 0))

    let zero = Version(0, 1, 2)
    XCTAssertEqual(zero.compatibleVersions.lowerBound, zero)
    XCTAssertEqual(zero.compatibleVersions.upperBound, Version(0, 2, 0))

    XCTAssertEqual("1.2.3", Version(1, 2, 3))
    XCTAssertEqual("1.2", Version(1, 2, 0))
    XCTAssertEqual("1", Version(1, 0, 0))

    XCTAssertNil(Version(String("")))
    XCTAssertNil(Version(String("A")))
    XCTAssertNil(Version(String("1.B")))
    XCTAssertNil(Version(String("1.2.C")))
    XCTAssertNil(Version(String("1.2.3.D")))
  }
}
