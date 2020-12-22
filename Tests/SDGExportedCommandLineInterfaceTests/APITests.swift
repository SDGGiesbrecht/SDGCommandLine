/*
 APITests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

import SDGExternalProcess
import SDGXCTestUtilities

import SDGExportedCommandLineInterface
import SDGCommandLineTestUtilities

class APITests: TestCase {

    let productsDirectory: URL = {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
          return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("Failed to find the products directory.")
      #else
        return Bundle.main.bundleURL
      #endif
    }()

    func testCommandInterface() throws {
      #if !(os(Windows) || os(Android))  // #workaround(SDGSwift 3.0.0, SwiftPM unavailable.)
        switch CommandInterface.loadInterface(of: URL(fileURLWithPath: #filePath), in: "en") {
        case .failure:
          break  // Expected.
        case .success:
          XCTFail("Loaded invalid interface.")
        }

        switch CommandInterface.loadInterface(
          of: productsDirectory.appendingPathComponent("empty‐tool"),
          in: "en"
        ) {
        case .failure:
          break  // Expected.
        case .success:
          XCTFail("Loaded unexported interface.")
        }

        let interface = try CommandInterface.loadInterface(
          of: productsDirectory.appendingPathComponent("test‐tool"),
          in: ""
        ).get()
        XCTAssert(interface.options.first?.isFlag == true)
      #endif
    }
}
