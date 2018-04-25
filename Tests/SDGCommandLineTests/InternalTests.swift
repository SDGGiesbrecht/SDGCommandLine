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

// [_Warning: Possibly temporary._]
import SDGSwift
import SDGSwiftPackageManager

@testable import SDGCommandLine
import SDGCommandLineLocalizations
import SDGCommandLineTestUtilities

class InternalTests : TestCase {

    static let rootCommand = Tool.command.withRootBehaviour()

    func testBuild() {
        XCTAssertEqual(Build.development, Build.development)
        XCTAssertNotEqual(Build.version(Version(1, 0, 0)), Build.development)
    }

    func testExternalToolVersions() {
        var shouldTest = ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
            ∨ ProcessInfo.processInfo.environment["CI"] ≠ nil
            ∨ ProcessInfo.processInfo.environment["TRAVIS"] ≠ nil

        #if os(macOS)
            // Xcode version differs from Travis version found first by the Swift Package Manager.
            shouldTest ∧= ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil
        #endif

        if shouldTest {
            XCTAssertErrorFree({
                let tools: [ExternalTool] = [
                    Git.default
                ]
                for tool in tools {
                    let output = Command.Output()
                    try tool.checkVersion(output: output)
                    XCTAssert(¬output.output.contains(StrictString("").formattedAsWarning().prefix(3)), "\(output.output)")
                }
            })
        }

        for (language, searchTerm) in [
            "en": "Attempting"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        var output = Command.Output()

                        output = Command.Output()
                        let git = Git(version: Version(0, 0, 0))
                        try git.checkVersion(output: output)
                        XCTAssert(output.output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                    XCTAssertThrowsError(containing: "Nonexistent") {
                        let output = Command.Output()
                        let nonexistent = ExternalTool(name: UserFacing<StrictString, InterfaceLocalization>({ _ in return "Nonexistent" }), webpage: UserFacing<StrictString, InterfaceLocalization>({ _ in return "" }), command: "nonexistent", version: Version(0, 0, 0), versionCheck: ["version"])
                        try nonexistent.checkVersion(output: output)
                    }
                }
        }
    }

    func testGit() {
        XCTAssertErrorFree({
            try FileManager.default.do(in: repositoryRoot) {
                let output = Command.Output()
                let ignored = try Git.default._ignoredFiles(output: output)
                XCTAssert(ignored.contains(where: { $0.lastPathComponent == ".build" }))
            }
        })
        XCTAssertErrorFree({
            let output = Command.Output()
            XCTAssert(try Git.default._versions(of: Package(url: URL(string: "https://github.com/realm/SwiftLint")!), output: output).contains(Version(0, 1, 0)), "Failed to detect remote versions.")
        })
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

    func testSwift() {

        XCTAssertErrorFree({
            let location = FileManager.default.url(in: .temporary, at: "ExecutablePackageTest")
            var output = Command.Output()

            let repository = try PackageRepository(initializingAt: location, type: .executable)
            try Shell.default.run(command: ["git", "init"], in: repository.location)

            defer { try? FileManager.default.removeItem(at: location) }

            try FileManager.default.do(in: location) {
                try Git.default.commitChanges(description: "Initialized.", output: output)

                try "...".save(to: location.appendingPathComponent("File.md"))
                try Git.default._differences(excluding: ["*.md"], output: output)
                do {
                    try Git.default._differences(excluding: [], output: output)
                    XCTFail("Difference unnoticed.")
                } catch {
                    // Expected
                }
            }
        })
    }

    func testVersion() {
        XCTAssertNil(Version(firstIn: "Blah blah blah..."))
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
            try testPackage.commitChanges(description: "Version 1.0.0", output: ignored)
            try testPackage.tag(version: Version(1, 0, 0), output: ignored)

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
            }

            // When the cache is empty...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Version (Empty Cache)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)
            var output: StrictString = ""

            // When the cache exists...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Version (Cached)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // When the cache is empty...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Development (Empty Cache)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // When the cache exists...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Use Development (Cached)", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            // Looking for version when it does not exist...
            testCommand(Tool.createCommand(), with: ["some‐invalid‐argument", "another‐invalid‐argument"], localizations: APILocalization.self, uniqueTestName: "Without Version", postprocess: postprocess, overwriteSpecificationInsteadOfFailing: false)

            let temporaryCache = FileManager.default.url(in: .temporary, at: UUID().uuidString)
            defer { try? FileManager.default.removeItem(at: temporaryCache) }
            let outputStream = Command.Output()
            try Package(url: testPackage.location)._execute(Version(1, 0, 0), of: [StrictString(testToolName)], with: [], cacheDirectory: temporaryCache, output: outputStream)
        }
    }

    func testVersionSubcommand() {
        LocalizationSetting(orderOfPrecedence: [["en"]]).do {
            XCTAssertErrorFree({
                testCommand(InternalTests.rootCommand, with: ["version"], localizations: APILocalization.self, uniqueTestName: "Version", overwriteSpecificationInsteadOfFailing: false)
            })
        }
    }

    static var allTests: [(String, (InternalTests) -> () throws -> Void)] {
        return [
            ("testBuild", testBuild),
            ("testExternalToolVersions", testExternalToolVersions),
            ("testGit", testGit),
            ("testSetLanguage", testSetLanguage),
            ("testSwift", testSwift),
            ("testVersion", testVersion),
            ("testVersionSelection", testVersionSelection),
            ("testVersionSubcommand", testVersionSubcommand)
        ]
    }
}
