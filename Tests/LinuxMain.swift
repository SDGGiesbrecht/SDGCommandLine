import XCTest

import SDGCommandLineTests
import SDGXCTestUtilities

var tests = [XCTestCaseEntry]()
tests += SDGCommandLineTests.__allTests()
tests += SDGXCTestUtilities.__allTests()

XCTMain(tests)
