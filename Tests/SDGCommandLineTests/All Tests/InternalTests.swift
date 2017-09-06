/*
 InternalTests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import SDGCornerstone

@testable import SDGCommandLine

class InternalTests : TestCase {

    func testSetLanguage() {
        let root = Tool.command.withRootBehaviour()

        XCTAssertErrorFree({
            try root.execute(with: ["set‐language", "zxx"])
        })
        XCTAssertEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)

        XCTAssertErrorFree({
            try root.execute(with: ["set‐language"])
        })
        XCTAssertNotEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)

        for (language, searchTerm) in [
            "en": "set‐language",
            "de": "sprache‐einstellen",
            "fr": "définir‐langue",
            "el": "οριζμός‐γλώσσας",
            "he": "הגדיר־את־שפה"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        let output =  try root.execute(with: ["help"])
                        XCTAssert(output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                }
        }
    }

    static var allTests: [(String, (InternalTests) -> () throws -> Void)] {
        return [
            ("testSetLanguage", testSetLanguage)
        ]
    }
}
