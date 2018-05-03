/*
 InternalTests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

import SDGLogic
import SDGCollections
import SDGExternalProcess

import SDGSwift
import SDGSwiftPackageManager

@testable import SDGCommandLine
import SDGCommandLineLocalizations
import SDGCommandLineTestUtilities

class InternalTests : TestCase {

    static let rootCommand = Tool.command.withRootBehaviour()

    func testExportInterface() {
        SDGCommandLineTestUtilities.testCommand(InternalTests.rootCommand, with: ["export‐interface"], localizations: InterfaceLocalization.self, uniqueTestName: "Export Interface", overwriteSpecificationInsteadOfFailing: false)
    }

    func testSetLanguage() {

        XCTAssertErrorFree({
            testCommand(InternalTests.rootCommand, with: ["set‐language", "zxx"], localizations: APILocalization.self, uniqueTestName: "Set Language", overwriteSpecificationInsteadOfFailing: false)
        })
        XCTAssertEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)

        XCTAssertErrorFree({
            testCommand(InternalTests.rootCommand, with: ["set‐language"], localizations: APILocalization.self, uniqueTestName: "Set Language to System", overwriteSpecificationInsteadOfFailing: false)
        })
        XCTAssertNotEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)

        for (language, searchTerm) in [
            "en": "set‐language"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        let output = try InternalTests.rootCommand.execute(with: ["help"])
                        XCTAssert(output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                }
        }
    }

    func testVersionSelection() {
        FileManager.default.delete(.cache)
        defer { FileManager.default.delete(.cache) }

        let currentPackage = ProcessInfo.packageURL
        defer { ProcessInfo.packageURL = currentPackage }

        XCTAssertErrorFree {
            var ignored = Command.Output()
            let testToolName = "tool"
            let location = FileManager.default.url(in: .temporary, at: testToolName)
            defer { FileManager.default.delete(.temporary) }

            let testPackage = try PackageRepository(initializingAt: location, type: .executable)
            try Shell.default.run(command: ["git", "init"], in: testPackage.location)

            try "print(CommandLine.arguments.dropFirst().joined(separator: \u{22} \u{22}))".save(to: testPackage.location.appendingPathComponent("Sources/" + testToolName + "/main.swift"))
            try testPackage.commitChanges(description: "Version 1.0.0")
            try testPackage.tag(version: Version(1, 0, 0))

            ProcessInfo.packageURL = testPackage.location

            func postprocess(_ output: inout String) {
                let temporaryDirectory = FileManager.default.url(in: .temporary, at: "File").deletingLastPathComponent()
                output.replaceMatches(for: temporaryDirectory.absoluteString, with: "[Temporary Directory]/")
                output.replaceMatches(for: temporaryDirectory.path, with: "[Temporary Directory]")

                let cacheDirectory = FileManager.default.url(in: .cache, at: "File").deletingLastPathComponent()
                output.replaceMatches(for: cacheDirectory.path, with: "[Cache]")

                output.scalars.replaceMatches(for: CompositePattern([
                    LiteralPattern("\n".scalars),
                    RepetitionPattern(ConditionalPattern({ $0 ∉ CharacterSet.whitespaces }), consumption: .lazy),
                    LiteralPattern("\trefs/heads/master".scalars)
                    ]), with: "\n[Commit Hash]\trefs/heads/master".scalars)
                output.scalars.replaceMatches(for: CompositePattern([
                    LiteralPattern("Development/".scalars),
                    RepetitionPattern(ConditionalPattern({ $0 ∉ CharacterSet.whitespaces }), consumption: .lazy),
                    LiteralPattern("/".scalars)
                    ]), with: "Development/[Commit Hash]/".scalars)
                output.scalars.replaceMatches(for: CompositePattern([
                    LiteralPattern(".build/".scalars),
                    RepetitionPattern(ConditionalPattern({ $0 ≠ "/" }), consumption: .lazy),
                    LiteralPattern("/release".scalars)
                    ]), with: ".build/[Operating System]/release".scalars)
            }

            // When the cache is empty...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Version (Empty Cache)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // When the cache exists...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Version (Cached)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // When the cache is empty...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Development (Empty Cache)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // When the cache exists...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Development (Cached)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // Looking for version when it does not exist...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Without Version", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)
        }
    }

    func testVersionSubcommand() {
        LocalizationSetting(orderOfPrecedence: [["en"]]).do {
            XCTAssertErrorFree({
                testCommand(InternalTests.rootCommand, with: ["version"], localizations: APILocalization.self, uniqueTestName: "Version", overwriteSpecificationInsteadOfFailing: false)
            })
        }
    }
}
