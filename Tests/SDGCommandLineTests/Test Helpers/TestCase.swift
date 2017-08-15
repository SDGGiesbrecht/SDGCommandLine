/*
 TestCase.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import Foundation

import SDGCornerstone
import SDGCommandLine

class TestCase : XCTestCase {

    static var initialized = false

    override func setUp() {
        if ¬TestCase.initialized {
            TestCase.initialized = true
            SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.SDGCommandLine.Tests")
        }
        super.setUp()
    }
}
