import XCTest

import SDGCommandLineTests
import SDGExportedCommandLineInterfaceTests

var tests = [XCTestCaseEntry]()
tests += SDGCommandLineTests.__allTests()
tests += SDGExportedCommandLineInterfaceTests.__allTests()

XCTMain(tests)
