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
                        let output =  try Tool.command.execute(with: ["execute"]) // [_Warni
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

    static var allTests: [(String, (CommandTests) -> () throws -> Void)] {
        return [
            ("testCommand", testCommand)
        ]
    }
}
