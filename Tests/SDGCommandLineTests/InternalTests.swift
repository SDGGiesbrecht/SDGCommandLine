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
import SDGExternalProcess

import SDGCommandLineLocalizations
@testable import SDGCommandLine

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
                    Git.default,
                    SwiftTool.default
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
                        let swift = SwiftTool(version: Version(0, 0, 0))
                        try swift.checkVersion(output: output)
                        XCTAssert(output.output.contains(searchTerm), "Expected output missing from “\(language)”: \(searchTerm)")

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

        XCTAssertErrorFree({
            let versionOutput = try Shell.default.run(command: ["swift", "\u{2D}\u{2D}version"])
            guard let systemVersion = Version(firstIn: versionOutput) else {
                XCTFail("Failed to detect system Swift version.")
                return
            }

            let output = Command.Output()
            let swift = SwiftTool(version: systemVersion)
            _ = try swift.execute(with: ["\u{2D}\u{2D}version"], output: output)
        })
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
            XCTAssert(try Git.default._versions(of: Package(_url: URL(string: "https://github.com/realm/SwiftLint")!), output: output).contains(Version(0, 1, 0)), "Failed to detect remote versions.")
        })
    }

    func testPackageRepository() {
        for language in ["en", "en\u{2D}US", "de", "fr", "el", "he"] {
            LocalizationSetting(orderOfPrecedence: [language]).do {
                XCTAssertErrorFree({
                    let packageLocation = FileManager.default.url(in: .temporary, at: "Package")

                    var output = Command.Output()
                    _ = try PackageRepository(initializingAt: packageLocation, executable: true, output: output)
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
            try FileManager.default.do(in: repositoryRoot) {
                var output = Command.Output()

                let packageStructure = try SwiftTool.default._packageStructure(output: output)

                XCTAssertEqual(packageStructure.name, "SDGCommandLine")

                XCTAssertEqual(packageStructure.libraryProductTargets, ["SDGCommandLine", "SDGCommandLineTestUtilities"])

                XCTAssertEqual(packageStructure.targets[0].name, "SDGCommandLine")
                XCTAssertEqual(packageStructure.targets[3].name, "SDGCommandLineTests")
            }
        })

        XCTAssertErrorFree({
            let location = FileManager.default.url(in: .temporary, at: "ExecutablePackageTest")
            var output = Command.Output()

            let repository = try PackageRepository(initializingAt: location, executable: true, output: output)
            defer { try? FileManager.default.removeItem(at: location) }

            try FileManager.default.do(in: location) {

                try "...".save(to: location.appendingPathComponent("File.md"))
                try Git.default._differences(excluding: ["*.md"], output: output)
                do {
                    try Git.default._differences(excluding: [], output: output)
                    XCTFail("Difference unnoticed.")
                } catch {
                    // Expected
                }

                let manifestLocation = location.appendingPathComponent("Package.swift")
                var manifest = try String(from: manifestLocation)
                manifest.replaceMatches(for: "dependencies: [\n", with: "products: [.executable(name: \u{22}ExecutablePackageTest\u{22}, targets: [\u{22}ExecutablePackageTest\u{22}])], dependencies: [\n")
                try manifest.save(to: manifestLocation)
                XCTAssert(try SwiftTool.default._packageStructure(output: output).executableProducts.count == 1)
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
            let testPackage = try PackageRepository(initializingAt: FileManager.default.url(in: .temporary, at: testToolName), executable: true, output: ignored)
            defer { FileManager.default.delete(.temporary) }

            try "print(CommandLine.arguments.dropFirst().joined(separator: \u{22} \u{22}))".save(to: testPackage.location.appendingPathComponent("Sources/" + testToolName + "/main.swift"))
            try testPackage.commitChanges(description: "Version 1.0.0", output: ignored)
            try testPackage.tag(version: Version(1, 0, 0), output: ignored)

            ProcessInfo.packageURL = testPackage.location

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

            let temporaryCache = FileManager.default.url(in: .temporary, at: UUID().uuidString)
            defer { try? FileManager.default.removeItem(at: temporaryCache) }
            let outputStream = Command.Output()
            try Package(url: testPackage.location)._execute(Version(1, 0, 0), of: [StrictString(testToolName)], with: [], cacheDirectory: temporaryCache, output: outputStream)
        }
    }

    func testVersionSubcommand() {
        LocalizationSetting(orderOfPrecedence: [["en"]]).do {
            XCTAssertErrorFree({
                let output = try InternalTests.rootCommand.execute(with: ["version"])
                XCTAssertEqual(output, "1.2.3")
            })
        }
    }

    func testXcode() {
        #if !os(Linux)
            for language in ["en", "el", "he"] {
                LocalizationSetting(orderOfPrecedence: [language]).do {
                    XCTAssertErrorFree({
                        let output = Command.Output()
                        _ = try _Xcode(_version: Version(8, 0)).execute(with: ["\u{2D}version"], output: output)
                    })
                }
            }
        #endif
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
            ("testVersionSubcommand", testVersionSubcommand),
            ("testXcode", testXcode)
        ]
    }
}