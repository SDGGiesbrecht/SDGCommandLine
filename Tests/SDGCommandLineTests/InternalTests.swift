/*
 InternalTests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization
import SDGExternalProcess
import SDGVersioning

import SDGSwift
import SDGSwiftPackageManager

@testable import SDGCommandLine

import SDGCommandLineLocalizations

import XCTest

import SDGLocalizationTestUtilities

import SDGCommandLineTestUtilities
import TestTool

class InternalTests: TestCase {

  static let rootCommand = Tool.command.withRootBehaviour()

  func testDirectArguments() {
    testCustomStringConvertibleConformance(
      of: DirectArguments(),
      localizations: InterfaceLocalization.self,
      uniqueTestName: "None",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testEmptyCache() {
    #if !os(Windows)  // #workaround(Swift 5.3.2, Segmentation fault.)
      testCommand(
        InternalTests.rootCommand,
        with: ["empty‐cache"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Empty Cache",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testExportInterface() {
    #if !os(Windows)  // #workaround(Swift 5.3.2, Segmentation fault.)
      func postprocess(_ output: inout String) {
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(
          for: "\n".scalars
            + RepetitionPattern(" ".scalars)
            + "\n".scalars,
          with: "\n\n".scalars
        )
      }
      SDGCommandLineTestUtilities.testCommand(
        InternalTests.rootCommand,
        with: ["export‐interface"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Export Interface",
        postprocess: postprocess,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testSetLanguage() throws {
    #if !os(Windows)  // #workaround(Swift 5.3.2, Segmentation fault.)
      testCommand(
        InternalTests.rootCommand,
        with: ["set‐language", "zxx"],
        localizations: APILocalization.self,
        uniqueTestName: "Set Language",
        overwriteSpecificationInsteadOfFailing: false
      )
      #if !os(WASI)  // #workaround(Swift 5.3.2, Web lacks UserDefaults.)
        XCTAssertEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)
      #endif

      testCommand(
        InternalTests.rootCommand,
        with: ["set‐language"],
        localizations: APILocalization.self,
        uniqueTestName: "Set Language to System",
        overwriteSpecificationInsteadOfFailing: false
      )
      #if !os(WASI)  // #workaround(Swift 5.3.2, Web lacks UserDefaults.)
        XCTAssertNotEqual(LocalizationSetting.current.value.resolved() as Language, .unsupported)
      #endif

      for (language, searchTerm) in [
        "en": "set‐language"
      ] as [String: StrictString] {
        try LocalizationSetting(orderOfPrecedence: [language]).do {
          let output = try InternalTests.rootCommand.execute(with: ["help"]).get()
          #if !os(WASI)  // #workaround(Swift 5.3.2, Web lacks UserDefaults.)
            XCTAssert(
              output.contains(searchTerm),
              "Expected output missing from “\(language)”: \(searchTerm)\n\(output)"
            )
          #endif
        }
      }
    #endif
  }

  func testOptions() {
    testCustomStringConvertibleConformance(
      of: Options(),
      localizations: InterfaceLocalization.self,
      uniqueTestName: "None",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testVersionSelection() throws {
    #if !os(Windows)  // #workaround(Swift 5.3.2, Segmentation fault.)
      // #workaround(Swift 5.3.2, Web lacks FileManager.)
      #if !os(WASI)
        FileManager.default.delete(.cache)
        defer { FileManager.default.delete(.cache) }

        let currentPackage = ProcessInfo.packageURL
        defer { ProcessInfo.packageURL = currentPackage }

        let testToolName = "tool"
        try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { temporaryDirectory in
          let location = temporaryDirectory.appendingPathComponent(testToolName)

          #if !(os(Windows) || os(Android))  // #workaround(SDGSwift 4.0.0, SwiftPM unavailable.)
            let testPackage = try PackageRepository.initializePackage(
              at: location,
              named: StrictString(location.lastPathComponent),
              type: .executable
            ).get()
            _ = try Shell.default.run(command: ["git", "init"], in: testPackage.location).get()

            try "print(CommandLine.arguments.dropFirst().joined(separator: \u{22} \u{22}))".save(
              to: testPackage.location.appendingPathComponent(
                "Sources/" + testToolName + "/main.swift"
              )
            )
            try testPackage.commitChanges(description: "Version 1.0.0").get()
            try testPackage.tag(version: Version(1, 0, 0)).get()

            ProcessInfo.packageURL = testPackage.location
          #endif

          func postprocess(_ output: inout String) {
            output.replaceMatches(
              for: temporaryDirectory.absoluteString,
              with: "[Temporary Directory]"
            )
            output.replaceMatches(for: temporaryDirectory.path, with: "[Temporary Directory]")

            let cacheDirectory = FileManager.default.url(in: .cache, at: "File")
              .deletingLastPathComponent()
            output.replaceMatches(for: cacheDirectory.path, with: "[Cache]")

            output.scalars.replaceMatches(
              for: "\n".scalars
                + RepetitionPattern(
                  ConditionalPattern({ $0 ∉ CharacterSet.whitespaces }),
                  consumption: .lazy
                )
                + "\trefs/heads/master".scalars,
              with: "\n[Commit Hash]\trefs/heads/master".scalars
            )
            output.scalars.replaceMatches(
              for: "Development/".scalars
                + RepetitionPattern(
                  ConditionalPattern({ $0 ∉ CharacterSet.whitespaces }),
                  consumption: .lazy
                )
                + "/".scalars,
              with: "Development/[Commit Hash]/".scalars
            )
            output.scalars.replaceMatches(
              for: ".build/".scalars
                + RepetitionPattern(ConditionalPattern({ $0 ≠ "/" }), consumption: .lazy)
                + "/release".scalars,
              with: ".build/[Operating System]/release".scalars
            )
            output.scalars.replaceMatches(
              for: "Cloning into \u{27}".scalars
                + RepetitionPattern(ConditionalPattern({ $0 ≠ "\u{27}" }), consumption: .lazy)
                + "\u{27}".scalars,
              with: "Cloning into \u{27}...\u{27}".scalars
            )
            output.scalars.replaceMatches(
              for: "tool ".scalars
                + RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" }), consumption: .lazy)
                + "/tool \u{2D}\u{2D}branch".scalars,
              with: "tool [...]/tool \u{2D}\u{2D}branch".scalars
            )
            output.scalars.replaceMatches(
              for: "tool ".scalars
                + RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" }), consumption: .lazy)
                + "/tool \u{2D}\u{2D}depth".scalars,
              with: "tool [...]/tool \u{2D}\u{2D}depth".scalars
            )
          }

          #if !os(Android)  // #workaround(workspace version 0.36.0, Emulator lacks Git.)
            // When the cache is empty...
            testCommand(
              Tool.createCommand(),
              with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"],
              localizations: APILocalization.self,
              uniqueTestName: "Use Version (Empty Cache)",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )

            // When the cache exists...
            testCommand(
              Tool.createCommand(),
              with: ["some‐invalid‐argument", "•use‐version", "1.0.0", "another‐invalid‐argument"],
              localizations: APILocalization.self,
              uniqueTestName: "Use Version (Cached)",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )

            // When the cache is empty...
            testCommand(
              Tool.createCommand(),
              with: [
                "some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument",
              ],
              localizations: APILocalization.self,
              uniqueTestName: "Use Development (Empty Cache)",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )

            // When the cache exists...
            testCommand(
              Tool.createCommand(),
              with: [
                "some‐invalid‐argument", "•use‐version", "development", "another‐invalid‐argument",
              ],
              localizations: APILocalization.self,
              uniqueTestName: "Use Development (Cached)",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )

            // Looking for version when it does not exist...
            testCommand(
              Tool.createCommand(),
              with: ["some‐invalid‐argument", "another‐invalid‐argument"],
              localizations: APILocalization.self,
              uniqueTestName: "Without Version",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )

            // Asking for something which is not a version...
            testCommand(
              Tool.createCommand(),
              with: [
                "some‐invalid‐argument", "•use‐version", "not‐a‐version",
                "another‐invalid‐argument",
              ],
              localizations: APILocalization.self,
              uniqueTestName: "Use Invalid Version",
              postprocess: postprocess,
              overwriteSpecificationInsteadOfFailing: false
            )
          #endif
        }
      #endif
    #endif
  }

  func testVersionSubcommand() {
    #if !os(Windows)  // #workaround(Swift 5.3.2, Segmentation fault.)
      // #workaround(Swift 5.3.2, Web lacks ProcessInfo.)
      #if !os(WASI)
        ProcessInfo.version = Version(1, 2, 3)
        testCommand(
          InternalTests.rootCommand,
          with: ["version"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Version",
          overwriteSpecificationInsteadOfFailing: false
        )
        ProcessInfo.version = nil
        testCommand(
          InternalTests.rootCommand,
          with: ["version"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Version (None)",
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    #endif
  }
}
