/*
 TestCase.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGExternalProcess
import SDGVersioning

import SDGSwift

import SDGCommandLine

import XCTest

import SDGXCTestUtilities

class TestCase: SDGXCTestUtilities.TestCase {

  static var alreadyInitialized = false

  override func setUp() {
    if ¬TestCase.alreadyInitialized {
      TestCase.alreadyInitialized = true
      ProcessInfo.version = Version(1, 2, 3)
      ProcessInfo.packageURL = URL(string: "https://domain.tld/Package")!
      Command.Output.testMode = true
      if ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] ≠ nil {
        // GitHub Actions do not have Git configured.
        _ = try? Shell.default.run(command: [
          "git", "config", "\u{2D}\u{2D}global", "user.name", "John Doe"
        ]).get()
        _ = try? Shell.default.run(command: [
          "git", "config", "\u{2D}\u{2D}global", "user.email", "john.doe@example.com"
        ]).get()
      }
    }
    super.setUp()
  }
}
