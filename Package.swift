// swift-tools-version:5.0

/*
 Package.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// #example(2, main.swift🇨🇦EN) #example(3, parrotLibrary🇨🇦EN) #example(4, parrotTests🇨🇦EN)
/// SDGCommandLine provides tools for implementing a command line interface.
///
/// > [יְהַלְלוּ אֶת־שֵׁם יהוה כִּי הוּא צִוָּה וְנִבְרָאוּ׃](https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV)
/// >
/// > [May they praise the name of the Lord, for He commanded and they came into being!](https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV)
/// >
/// > ―a psalmist
///
/// ### Features
///
/// - Automatic parsing of options and subcommands
/// - Automatic `help` subcommand
/// - Testable output
/// - Colour formatting tools
///     - Automatic `•no‐colour` option
/// - Interface localization
///     - Automatic `set‐language` subcommand to set language preferences.
///     - Automatic `•language` option to run in a specific language only once.
/// - Versioning tools
///     - Automatic `version` subcommand
///     - Automatic `•use‐version` option to attempt to download and temporarily use a specific version instead of the one which is installed (only for public Swift packages).
///
/// ### Example Usage
///
/// This example creates a tool with the following interface:
///
/// ```shell
/// $ parrot speak
/// Squawk!
///
/// $ parrot speak •phrase "Hello, world!"
/// Hello, world!
/// ```
///
/// `main.swift` must consist of the following lines:
///
/// ```swift
/// ProcessInfo.applicationIdentifier = "tld.Developper.Parrot"
/// ProcessInfo.version = Version(1, 0, 0)
/// ProcessInfo.packageURL = URL(string: "https://website.tld/Parrot")
///
/// parrot.executeAsMain()
/// ```
///
/// The rest can be anywhere in the project (but putting it in a separate, testable library module is recommended):
///
/// ```swift
/// import SDGCommandLine
///
/// public let parrot = Command(name: UserFacing<StrictString, MyLocalizations>({ _ in "parrot" }),
///                             description: UserFacing<StrictString, MyLocalizations>({ _ in "behaves like a parrot." }),
///                             subcommands: [speak])
///
/// let speak = Command(name: UserFacing<StrictString, MyLocalizations>({ _ in "speak" }),
///                     description: UserFacing<StrictString, MyLocalizations>({ _ in "speaks." }),
///                     directArguments: [],
///                     options: [phrase],
///                     execution: { (_, options: Options, output: Command.Output) throws -> Void in
///
///                         if let specific = options.value(for: phrase) {
///                             output.print(specific)
///                         } else {
///                             output.print("Squawk!")
///                         }
/// })
///
/// let phrase = Option<StrictString>(name: UserFacing<StrictString, MyLocalizations>({ _ in "phrase" }),
///                                   description: UserFacing<StrictString, MyLocalizations>({ _ in "A custom phrase to speak." }),
///                                   type: ArgumentType.string)
///
/// enum MyLocalizations : String, InputLocalization {
///     case english = "en"
///     internal static let cases: [MyLocalizations] = [.english]
///     internal static let fallbackLocalization: MyLocalizations = .english
/// }
/// ```
///
/// Tests are easy to set up:
///
/// ```swift
/// func testParrot() {
///     switch parrot.execute(with: ["speak", "•phrase", "Hello, world!"]) {
///     case .success(let output):
///         XCTAssertEqual(output, "Hello, world!")
///     case .failure:
///         XCTFail("The parrot is not co‐operating.")
///     }
/// }
/// ```
let package = Package(
    name: "SDGCommandLine",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        // @documentation(SDGCommandLine)
        /// Tools for implementing a command line interface.
        .library(name: "SDGCommandLine", targets: ["SDGCommandLine"]),
        // @documentation(SDGCommandLineTestUtilities)
        /// Utilities for testing modules which link against `SDGCommandLine`.
        .library(name: "SDGCommandLineTestUtilities", targets: ["SDGCommandLineTestUtilities"]),
        // @documentation(SDGExportedCommandLineInterface)
        /// Loading a tool’s exported interface for documentation purposes.
        .library(name: "SDGExportedCommandLineInterface", targets: ["SDGExportedCommandLineInterface"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(1, 0, 0)),
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .upToNextMinor(from: Version(0, 12, 0)))
    ],
    targets: [

        // Products

        // #documentation(SDGCommandLine)
        /// Tools for implementing a command line interface.
        .target(name: "SDGCommandLine", dependencies: [
            "SDGCommandLineLocalizations",
            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGMathematics", package: "SDGCornerstone"),
            .product(name: "SDGCollections", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGSwift", package: "SDGSwift")
            ], swiftSettings: [
                .define("INTERFACE_EXPORT", .when(configuration: .debug))
            ]),

        // #documentation(SDGCommandLineTestUtilities)
        /// Utilities for testing modules which link against `SDGCommandLine`.
        .target(name: "SDGCommandLineTestUtilities", dependencies: [
            "SDGCommandLine",
            "SDGCommandLineLocalizations",
            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGTesting", package: "SDGCornerstone"),
            .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone")
            ]),

        // #documentation(SDGExportedCommandLineInterface)
        /// Loading a tool’s exported interface for documentation purposes.
        .target(name: "SDGExportedCommandLineInterface", dependencies: [
            "SDGCommandLine",
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGPersistence", package: "SDGCornerstone"),
            .product(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),

        // Internal

        .target(name: "SDGCommandLineLocalizations", dependencies: [
            .product(name: "SDGLocalization", package: "SDGCornerstone")
            ]),

        // Tests

        .testTarget(name: "SDGCommandLineTests", dependencies: [
            "SDGCommandLineTestUtilities",
            "TestTool",
            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGCollections", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGSwift", package: "SDGSwift"),
            .product(name: "SDGSwiftPackageManager", package: "SDGSwift")
            ]),

        .testTarget(name: "SDGExportedCommandLineInterfaceTests", dependencies: [
            "SDGExportedCommandLineInterface",
            "SDGCommandLineTestUtilities",
            "test‐tool",
            "empty‐tool",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
            ]),

        .target(name: "TestTool", dependencies: [
            "SDGCommandLine",
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone")
            ], path: "Tests/TestTool"),

        .target(name: "test‐tool", dependencies: [
            "SDGCommandLine",
            "TestTool"
            ], path: "Tests/test‐tool"),

        .target(name: "empty‐tool", path: "Tests/empty‐tool")
    ]
)
