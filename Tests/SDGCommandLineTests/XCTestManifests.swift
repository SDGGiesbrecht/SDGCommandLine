import XCTest

extension APITests {
    static let __allTests = [
        ("testCommand", testCommand),
        ("testDirectArgument", testDirectArgument),
        ("testEnumerationOption", testEnumerationOption),
        ("testFormatting", testFormatting),
        ("testHelp", testHelp),
        ("testLanguage", testLanguage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testLocalizations", testLocalizations),
        ("testNoColour", testNoColour),
        ("testOption", testOption),
        ("testVersion", testVersion),
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testSetLanguage", testSetLanguage),
        ("testVersionSelection", testVersionSelection),
        ("testVersionSubcommand", testVersionSubcommand),
    ]
}

extension ReadMeExampleTests {
    static let __allTests = [
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testParrot", testParrot),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests),
        testCase(ReadMeExampleTests.__allTests),
        testCase(TestCase.__allTests),
    ]
}
#endif
