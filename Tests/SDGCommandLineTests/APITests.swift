/*
 APITests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

import SDGCommandLineTestUtilities
import SDGCommandLineLocalizations

class APITests : TestCase {

    func testCommand() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute"], localizations: Language.self, uniqueTestName: "Execution", overwriteSpecificationInsteadOfFailing: false)

        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["fail"], localizations: Language.self, uniqueTestName: "Failure", overwriteSpecificationInsteadOfFailing: false)

        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["ausführen"], localizations: Language.self, uniqueTestName: "Foreign Command", overwriteSpecificationInsteadOfFailing: false)
    }

    func testDirectArgument() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["reject‐argument", "..."], localizations: SystemLocalization.self, uniqueTestName: "Invalid Argument", overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "invalid"], localizations: SystemLocalization.self, uniqueTestName: "Unexpected Argument", overwriteSpecificationInsteadOfFailing: false)
    }

    func testEnumerationOption() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•colour", "red"], localizations: Language.self, uniqueTestName: "Accept Enumeration", overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•colour", "rot"], localizations: Language.self, uniqueTestName: "Accept Foreign Enumeration", overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•colour", "none"], localizations: SystemLocalization.self, uniqueTestName: "Invalid Enumeration", overwriteSpecificationInsteadOfFailing: false)
    }

    func testFormatting() {
        XCTAssertErrorFree({
            let output = try Tool.command.execute(with: ["demonstrate‐text‐formatting"])
            XCTAssert(output.contains(StrictString("\u{1B}[1m")), "Bold formatting missing.")
            XCTAssert(output.contains(StrictString("\u{1B}[22m")), "Bold formatting never reset.")
        })
    }

    func testHelp() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "help"], localizations: SystemLocalization.self, uniqueTestName: "Help", overwriteSpecificationInsteadOfFailing: false)
    }

    func testLanguage() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["help", "•language", "he"], localizations: Language.self, uniqueTestName: "Language Selection by Code", overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["help", "•language", "🇬🇷ΕΛ"], localizations: Language.self, uniqueTestName: "Language Selection by Icon", overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoColour() {
        XCTAssertErrorFree({
            let output = try Tool.command.execute(with: ["help", "•no‐colour"])
            XCTAssert(¬output.contains("\u{1B}"), "Failed to disable colour.")
        })
    }

    func testOption() {
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•string", "Changed using an option."], localizations: Language.self, uniqueTestName: "Unicode Option", overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "\u{2D}\u{2D}string", "Changed using an option."], localizations: Language.self, uniqueTestName: "ASCII Option", overwriteSpecificationInsteadOfFailing: false)

        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•informal"], localizations: Language.self, uniqueTestName: "Flag", overwriteSpecificationInsteadOfFailing: false)

        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•invalid"], localizations: SystemLocalization.self, uniqueTestName: "Invalid Option", overwriteSpecificationInsteadOfFailing: false)

        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•string"], localizations: SystemLocalization.self, uniqueTestName: "Missing Option Argument", allowColour: true, overwriteSpecificationInsteadOfFailing: false)
        SDGCommandLineTestUtilities.testCommand(Tool.command, with: ["execute", "•unsatisfiable", "..."], localizations: SystemLocalization.self, uniqueTestName: "Invalid Option Argument", allowColour: true, overwriteSpecificationInsteadOfFailing: false)
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

        XCTAssertNil(Version(""))
        XCTAssertNil(Version("A"))
        XCTAssertNil(Version("1.B"))
        XCTAssertNil(Version("1.2.C"))
        XCTAssertNil(Version("1.2.3.D"))
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCommand", testCommand),
            ("testDirectArgument", testDirectArgument),
            ("testEnumerationOption", testEnumerationOption),
            ("testFormatting", testFormatting),
            ("testHelp", testHelp),
            ("testLanguage", testLanguage),
            ("testNoColour", testNoColour),
            ("testOption", testOption),
            ("testVersion", testVersion)
        ]
    }
}
