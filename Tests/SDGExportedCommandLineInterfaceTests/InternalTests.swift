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

import SDGXCTestUtilities

class InternalTests: TestCase {

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
