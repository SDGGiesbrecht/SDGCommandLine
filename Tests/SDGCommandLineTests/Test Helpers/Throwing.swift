/*
 Throwing.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import Foundation

import SDGCornerstone
import SDGCommandLine

private func description(of error: Error) -> String {
    if let command = error as? Command.Error {
        return String(command.describe())
    } else {
        return error.localizedDescription
    }
}

internal func XCTAssertErrorFree(file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
    } catch let error {
        XCTFail(description(of: error), file: file, line: line)
    }
}

internal func XCTAssertThrows<E : Error>(_ error: E, file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
        XCTFail("The expected error was never thrown:\n" + description(of: error), file: file, line: line)
    } catch let thrown {
        XCTAssertEqual(description(of: thrown), description(of: error), file: file, line: line)
    }
}

internal func XCTAssertThrowsError(containing searchTerm: StrictString, file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
        XCTFail("The expected error was never thrown:\n...\(searchTerm)...", file: file, line: line)
    } catch let thrown {
        XCTAssert(description(of: thrown).contains(String(searchTerm)), "Error message does not contain “\(searchTerm)”:\n\(description(of: thrown))", file: file, line: line)
    }
}
