/*
 InternalTests.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2021–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

@testable import SDGExportedCommandLineInterface

import XCTest

import SDGPersistenceTestUtilities
import SDGXCTestUtilities

class InternalTests: TestCase {

  func testCommandInterface() throws {
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      _ = try CommandInterface(
        export: try String(
          from: testSpecificationDirectory()
            .appendingPathComponent("Exports")
            .appendingPathComponent("Version 1.json")
        )
      )
      _ = try CommandInterface(
        export: String(
          from: testSpecificationDirectory()
            .appendingPathComponent("Exports")
            .appendingPathComponent("Version 2.json")
        )
      )
    #endif
  }

  func testOptionInterface() {
    let option = OptionInterface(
      identifier: "...",
      name: "...",
      description: "...",
      type: ArgumentInterface(identifier: "...", name: "...", description: "...")
    )
    _ = option.isFlag
  }
}
