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
import SDGCommandLine

class APITests : TestCase {

    func testCommand() {
        for (language, searchTerm) in [
            "en": "Hello",
            "de": "Guten Tag"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        let output = try Tool.command.execute(with: ["execute"])
                        XCTAssert(output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                }
        }

        XCTAssertThrows(Fail.error, {
            try Tool.command.execute(with: ["fail"])
        })

        for (language, searchTerm) in [
            "en": "I cannot",
            "de": "kann ich nicht"
            ] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssert(String(Fail.error.describe()).contains(searchTerm), "Expected error details missing from “\(language)”: \(searchTerm)")
                }
        }

        let helpNames: [String: StrictString] = [
            "en": "help", // [_Warning: Test localization of this with a specification instead._]
            "de": "hilfe",
            "fr": "aide",
            "el": "βοήθεια",
            "he": "עזרה"
        ]

        for (language, searchTerm) in helpNames {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertErrorFree({
                    let output = try Tool.command.execute(with: ["help"])
                    XCTAssert(output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                })
            }
        }
        LocalizationSetting(orderOfPrecedence: ["de"]).do {
            for (_, help) in helpNames {
                XCTAssertErrorFree({
                    let output = try Tool.command.execute(with: [help])
                    XCTAssert(output.contains(StrictString("hilfe")), "Expected output missing from “de”: hilfe")
                })
            }
        }
    }

    func testDirectArgument() {
        let invalidArgumentMessages: [String: StrictString] = [
            "en": "invalid",
            "en\u{2D}US": "invalid" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, invalidArgument) in invalidArgumentMessages {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertThrowsError(containing: invalidArgument) {
                    try Tool.command.execute(with: ["reject‐argument", "..."])
                }
            }
        }
    }

    func testEnumerationOption() {
        LocalizationSetting(orderOfPrecedence: ["en"]).do {
            XCTAssertErrorFree({
                try Tool.command.execute(with: ["execute", "•colour", "red"])
            })
            XCTAssertErrorFree({
                try Tool.command.execute(with: ["execute", "•colour", "rot"])
            })
            XCTAssertThrowsError(containing: "colour") {
                try Tool.command.execute(with: ["execute", "•colour", "none"])
            }
        }

        let enumerationLists: [String: StrictString] = [
            "en\u{2D}GB": "or",
            "en\u{2D}US": "or",
            "en": "or" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, or) in enumerationLists {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertErrorFree({
                    let output = try Tool.command.execute(with: ["execute", "help"])
                    XCTAssert(output.contains(or), "Expected output missing: \(or)")
                })
            }
        }
    }

    func testFormatting() {
        XCTAssertErrorFree({
            let output = try Tool.command.execute(with: ["demonstrate‐text‐formatting"])
            XCTAssert(output.contains(StrictString("\u{1B}[1m")), "Bold formatting missing.")
            XCTAssert(output.contains(StrictString("\u{1B}[22m")), "Bold formatting never reset.")
        })
    }

    func testHelp() {
        LocalizationSetting(orderOfPrecedence: ["en"]).do {
            XCTAssertErrorFree({
                let output = try Tool.command.execute(with: ["execute", "help"])
                XCTAssert(output.contains(StrictString("tool")), "Root command missing.")
                XCTAssert(output.contains(StrictString("help")), "Subcommand missing.")
                XCTAssert(output.contains(StrictString("•string")), "Option missing.")
                XCTAssert(output.contains(StrictString("[string]")), "Argument type missing.")
                XCTAssert(¬output.contains(StrictString("[Boolean]")), "Boolean type not handled uniquely.")
            })
        }
    }

    func testLanguage() {
        XCTAssertErrorFree({
            let expected: StrictString = "עזרה"
            let output = try Tool.command.execute(with: ["help", "•language", "he"])
            XCTAssert(output.contains(expected), "Expected output missing: \(expected)")
        })

        XCTAssertErrorFree({
            let expected: StrictString = "βοήθεια"
            let output = try Tool.command.execute(with: ["help", "•language", "🇬🇷ΕΛ"])
            XCTAssert(output.contains(expected), "Expected output missing: \(expected)")
        })
    }

    func testNoColour() {
        XCTAssertErrorFree({
            let output = try Tool.command.execute(with: ["help", "•no‐colour"])
            XCTAssert(¬output.contains("\u{1B}"), "Failed to disable colour.")
        })
    }

    func testOption() {
        XCTAssertErrorFree({
            let text: StrictString = "Changed using an option."
            let output = try Tool.command.execute(with: ["execute", "•string", text])
            XCTAssert(output.contains(text), "Expected output missing: \(text)")
        })

        XCTAssertErrorFree({
            let text: StrictString = "Changed using an option."
            let output = try Tool.command.execute(with: ["execute", "\u{2D}\u{2D}string", text])
            XCTAssert(output.contains(text), "Expected output missing: \(text)")
        })

        LocalizationSetting(orderOfPrecedence: ["en"]).do {
            XCTAssertErrorFree({
                let text: StrictString = "Hi!"
                let output = try Tool.command.execute(with: ["execute", "•informal"])
                XCTAssert(output.contains(text), "Expected output missing: \(text)")
            })
        }

        let unexpectedArgumentMessages: [String: StrictString] = [
            "en": "Unexpected" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, unexpectedArgument) in unexpectedArgumentMessages {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertThrowsError(containing: unexpectedArgument) {
                    try Tool.command.execute(with: ["execute", "invalid"])
                }

                let subcommand: StrictString
                switch language {
                case "de":
                    subcommand = "ausführen"
                default:
                    subcommand = "execute"
                }
                XCTAssertThrowsError(containing: subcommand) {
                    try Tool.command.execute(with: ["execute", "invalid"])
                }
            }
        }

        let invalidOptionMessages: [String: StrictString] = [
            "en": "Invalid" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, invalidOption) in invalidOptionMessages {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertThrowsError(containing: invalidOption) {
                    try Tool.command.execute(with: ["execute", "•invalid"])
                }

                let subcommand: StrictString
                switch language {
                case "de":
                    subcommand = "ausführen"
                default:
                    subcommand = "execute"
                }
                XCTAssertThrowsError(containing: subcommand) {
                    try Tool.command.execute(with: ["execute", "•invalid"])
                }
            }
        }

        let missingArgumentMessages: [String: StrictString] = [
            "en": "missing",
            "en\u{2D}US": "missing" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, missingArgument) in missingArgumentMessages {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertThrowsError(containing: missingArgument) {
                    try Tool.command.execute(with: ["execute", "•string"])
                }

                let subcommand: StrictString
                switch language {
                case "de":
                    subcommand = "ausführen"
                default:
                    subcommand = "execute"
                }
                XCTAssertThrowsError(containing: subcommand) {
                    try Tool.command.execute(with: ["execute", "•string"])
                }
            }
        }

        let invalidArgumentMessages: [String: StrictString] = [
            "en": "invalid",
            "en\u{2D}US": "invalid" // [_Warning: Test localization of this with a specification instead._]
        ]
        for (language, invalidArgument) in invalidArgumentMessages {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertThrowsError(containing: invalidArgument) {
                    try Tool.command.execute(with: ["execute", "•unsatisfiable", "..."])
                }

                let subcommand: StrictString
                switch language {
                case "de":
                    subcommand = "ausführen"
                default:
                    subcommand = "execute"
                }
                XCTAssertThrowsError(containing: subcommand) {
                    try Tool.command.execute(with: ["execute", "•unsatisfiable", "..."])
                }
            }
        }
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
