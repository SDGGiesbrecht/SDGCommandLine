/*
 TestCase.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import Foundation

import SDGXCTestUtilities

import SDGCommandLine

class TestCase : SDGXCTestUtilities.TestCase {

    static var initialized = false

    override func setUp() {
        if ¬TestCase.initialized {
            TestCase.initialized = true
            ProcessInfo.version = Version(1, 2, 3)
            ProcessInfo.packageURL = URL(string: "https://domain.tld/Package")!
            Command.Output.testMode = true
        }
        super.setUp()
    }
}
