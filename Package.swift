// swift-tools-version:4.1

/*
 Package.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

let package = Package(
    name: "SDGCommandLine",
    products: [
        .library(name: "SDGCommandLine", targets: ["SDGCommandLine"]),
        .library(name: "SDGCommandLineTestUtilities", targets: ["SDGCommandLineTestUtilities"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: /* Exported! */ Version(0, 9, 1)),
        // [_Warning: Do not merge pointing at a branch._]
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .branch(/* Exported! */ "master"))
    ],
    targets: [
        // Products
        .target(name: "SDGCommandLine", dependencies: [
            "SDGCommandLineLocalizations",
            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGLogic", package: "SDGCornerstone"),
            .productItem(name: "SDGMathematics", package: "SDGCornerstone"),
            .productItem(name: "SDGCollections", package: "SDGCornerstone"),
            .productItem(name: "SDGText", package: "SDGCornerstone"),
            .productItem(name: "SDGLocalization", package: "SDGCornerstone"),
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .productItem(name: "SDGSwift", package: "SDGSwift")
            ]),
        .target(name: "SDGCommandLineTestUtilities", dependencies: [
            "SDGCommandLine",
            "SDGCommandLineLocalizations",
            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGTesting", package: "SDGCornerstone"),
            .productItem(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone")
            ]),
        // Internal
        .target(name: "SDGCommandLineLocalizations", dependencies: [
            .productItem(name: "SDGLocalization", package: "SDGCornerstone")
            ]),
        // Tests
        .testTarget(name: "SDGCommandLineTests", dependencies: [
            "SDGCommandLineTestUtilities",
            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGLogic", package: "SDGCornerstone"),
            .productItem(name: "SDGCollections", package: "SDGCornerstone"),
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .productItem(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGSwift", package: "SDGSwift"),
            .productItem(name: "SDGSwiftPackageManager", package: "SDGSwift")
            ])

        // [_Workaround: Until Workspace can exclude these from test coverage validation. (workspace version 0.6.0)_]
        /*.target(name: "test‐tool", dependencies: [
            "SDGCommandLine"
            ])*/
    ]
)
