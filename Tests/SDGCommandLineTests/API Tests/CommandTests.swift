/*
 CommandTests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import SDGCornerstone
import SDGCommandLine

class CommandTests : TestCase {

    func testCommand() {
        for (language, searchTerm) in [
            "en": "Hello",
            "de": "Guten Tag"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        let output =  try Tool.command.execute(with: ["execute"])
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
            "en": "help",
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
            "en": "or",
            "de": "oder",
            "fr": "ou",
            "el": "ή",
            "he": "או"
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

    func testOption() {
        XCTAssertErrorFree({
            let text: StrictString = "Changed using an option."
            let output =  try Tool.command.execute(with: ["execute", "•string", text])
            XCTAssert(output.contains(text), "Expected output missing: \(text)")
        })

        XCTAssertErrorFree({
            let text: StrictString = "Changed using an option."
            let output =  try Tool.command.execute(with: ["execute", "\u{2D}\u{2D}string", text])
            XCTAssert(output.contains(text), "Expected output missing: \(text)")
        })

        LocalizationSetting(orderOfPrecedence: ["en"]).do {
            XCTAssertErrorFree({
                let text: StrictString = "Hi!"
                let output =  try Tool.command.execute(with: ["execute", "•informal"])
                XCTAssert(output.contains(text), "Expected output missing: \(text)")
            })
        }

        let unexpectedArgumentMessages: [String: StrictString] = [
            "en": "Unexpected",
            "de": "Unerwartetes",
            "fr": "inattendu",
            "el": "Απροσδόκητο",
            "he": "לא צפוי"
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
            "en": "Invalid",
            "de": "Ungültige",
            "fr": "invalide",
            "el": "Άκυρη",
            "he": "לא בתוקף"
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
            "en\u{2D}US": "missing",
            "de": "fehlt",
            "fr": "manque",
            "el": "λείπει",
            "he": "חסר"
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
            "en\u{2D}US": "invalid",
            "de": "ungültig",
            "fr": "invalide",
            "el": "άκυρο",
            "he": "לא בתוקף"
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

    static var allTests: [(String, (CommandTests) -> () throws -> Void)] {
        return [
            ("testCommand", testCommand),
            ("testFormatting", testFormatting),
            ("testHelp", testHelp),
            ("testOption", testOption)
        ]
    }
}
