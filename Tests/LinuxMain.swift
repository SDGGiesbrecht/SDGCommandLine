import XCTest

import SDGCommandLineTests

var tests = [XCTestCaseEntry]()
tests += SDGCommandLineTests.__allTests()

XCTMain(tests)
