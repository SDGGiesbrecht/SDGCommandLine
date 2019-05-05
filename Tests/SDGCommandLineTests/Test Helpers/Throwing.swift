/*
 Throwing.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import Foundation

import SDGCommandLine

internal func XCTAssertErrorFree(file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    #warning("This is not necessary.")
    do {
        try expression()
    } catch let error {
        XCTFail("\(error)", file: file, line: line)
    }
}
