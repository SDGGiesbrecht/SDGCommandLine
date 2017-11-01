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

    func testBuild() {
        XCTAssertEqual(Build.development, Build.development)
        XCTAssertNotEqual(Build.version(Version(1, 0, 0)), Build.development)
    }

    func testGit() {
        do {
            try FileManager.default.do(in: repositoryRoot) {
                var output = Command.Output()
                let ignored = try Git.default._ignoredFiles(output: &output)
                XCTAssert(ignored.contains(where: { $0.lastPathComponent.contains("Validate") }))
            }
        } catch {
            XCTFail("Unexpected error.")
        }
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

        for (language, searchTerm) in [
            "en": "Attempting",
            "de": "Versucht",
            "fr": "Tente",
            "el": "Προσπαθεί",
            "he": "מנסה"
            ] as [String: StrictString] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        var output = Command.Output()
                        let swift = SwiftTool(version: Version(0, 0, 0))
                        try swift.checkVersion(output: &output)
                        XCTAssert(output.output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")

                        output = Command.Output()
                        let git = Git(version: Version(0, 0, 0))
                        try git.checkVersion(output: &output)
                        XCTAssert(output.output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")
                    })
                    XCTAssertThrowsError(containing: "Nonexistent") {
                        var output = Command.Output()
                        let nonexistent = ExternalTool(name: UserFacingText<InterfaceLocalization, Void>({ (_, _) in return "Nonexistent" }), webpage: UserFacingText<InterfaceLocalization, Void>({ (_, _) in return "" }), command: "nonexistent", version: Version(0, 0, 0), versionCheck: ["version"])
                        try nonexistent.checkVersion(output: &output)
                    }
                }
        }
    }

    func testPackageRepository() {
        for language in ["en", "en\u{2D}US", "de", "fr", "el", "he"] {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertErrorFree({
                    let packageLocation = FileManager.default.url(in: .temporary, at: "Package")

                    var output = Command.Output()
                    _ = try PackageRepository(initializingAt: packageLocation, output: &output)
                    defer { FileManager.default.delete(.temporary) }
                })
            }
        }
        XCTAssertEqual(PackageRepository(_alreadyAt: repositoryRoot).location, repositoryRoot)
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

    func testSwift() {
        do {
            try FileManager.default.do(in: repositoryRoot) {
                var output = Command.Output()
                let targets = try SwiftTool.default._targets(output: &output)
                XCTAssert(targets.contains(where: { $0.name == "SDGCommandLine" }))
                XCTAssert(targets.contains(where: { $0.name == "SDGCommandLineTests" }))
            }
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testVersion() {
        XCTAssertNil(Version(firstIn: "Blah blah blah..."))
    }

    func testVersionSelection() {
        FileManager.default.delete(.cache)
        defer { FileManager.default.delete(.cache) }

        let currentPackage = Package.current
        defer { Package.current = currentPackage }

        XCTAssertErrorFree {
            var ignored = Command.Output()
            let testToolName = "tool"
            let testPackage = try PackageRepository(initializingAt: FileManager.default.url(in: .temporary, at: testToolName), output: &ignored)
            defer { FileManager.default.delete(.temporary) }

            try "print(CommandLine.arguments.dropFirst().joined(separator: \u{22} \u{22}))".save(to: testPackage.url(for: "Sources/" + testToolName + "/main.swift"))
            try testPackage.commitChanges(description: "Version 1.0.0", output: &ignored)
            try testPackage.tag(version: Version(1, 0, 0), output: &ignored)

            Package.current = Package(url: testPackage.location)

            // When the cache is empty...
            var output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument\n".scalars))

            // When the cache exists...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument\n".scalars))

            // When the cache is empty...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument\n".scalars))

            // When the cache exists...
            output = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument"])
            XCTAssert(output.hasSuffix("some‐invalid‐argument another‐invalid‐argument\n".scalars))

            LocalizationSetting(orderOfPrecedence: [["en"]]).do {
                // Looking for version when it does not exist...
                XCTAssertThrowsError(containing: "some‐invalid‐argument") {
                    _ = try Tool.createCommand().execute(with: ["some‐invalid‐argument", "another‐invalid‐argument"])
                }
            }
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
            ("testBuild", testBuild),
            ("testExternalToolVersions", testExternalToolVersions),
            ("testGit", testGit),
            ("testPackageRepository", testPackageRepository),
            ("testSetLanguage", testSetLanguage),
            ("testSwift", testSwift),
            ("testVersion", testVersion),
            ("testVersionSelection", testVersionSelection),
            ("testVersionSubcommand", testVersionSubcommand)
        ]
    }
}
