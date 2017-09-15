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

    static let rootCommand = Tool.command.withRootBehaviour()

    func testExternalToolVersions() {
        XCTAssertErrorFree({
            let tools: [ExternalTool] = [
                Git.default,
                SwiftTool.default
            ]
            for tool in tools {
                var output = Command.Output()
                try tool.checkVersion(output: &output)
                XCTAssert(¬output.output.contains(StrictString("").formattedAsWarning().prefix(3)), "\(output.output)")
            }
        })
    }

    func testSetLanguage() {

        XCTAssertErrorFree({
            try InternalTests.rootCommand.execute(with: ["set‐language", "zxx"])
        })
        XCTAssertEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)

        XCTAssertErrorFree({
            try InternalTests.rootCommand.execute(with: ["set‐language"])
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
                        let output =  try InternalTests.rootCommand.execute(with: ["help"])
                        XCTAssert(output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                }
        }
    }

    func testVersionSelection() {
        let currentPackage = Package.current
        defer { Package.current = currentPackage }

        XCTAssertErrorFree {
            var ignored = Command.Output()
            let testPackage = try PackageRepository(initializingAt: FileManager.default.url(in: .temporary, at: "tool"), output: &ignored)
            defer { FileManager.default.delete(.temporary) }

            try "print(CommandLine.arguments.dropFirst().joined(separator: \u{22}\u{22}))".save(to: testPackage.url(for: "Sources/main.swift"))
            try testPackage.commitChanges(description: "Version 1.0.0", output: &ignored)
            try testPackage.tag(version: Version(1, 0, 0), output: &ignored)

            Package.current = testPackage.package

            // When the cache is empty...
            var output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument".scalars))

            // When the cache exists...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument".scalars))

            // When the cache is empty...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument".scalars))

            // When the cache exists...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument".scalars))
        }
    }

    func testVersionSubcommand() {
        LocalizationSetting(orderOfPrecedence: [["en"]]).do {
            XCTAssertErrorFree({
                let output =  try InternalTests.rootCommand.execute(with: ["version"])
                XCTAssertEqual(output, "1.2.3")
            })
        }
    }

    static var allTests: [(String, (InternalTests) -> () throws -> Void)] {
        return [
            ("testExternalToolVersions", testExternalToolVersions),
            ("testSetLanguage", testSetLanguage),
            ("testVersionSubcommand", testVersionSubcommand)
        ]
    }
}
