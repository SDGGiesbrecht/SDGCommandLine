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
        .library(name: "SDGCommandLine", targets: ["SDGCommandLine"])
    ],
    dependencies: [
        // [_Warning: Use particular version._]
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .branch("swift‐4.1"))
    ],
    targets: [
        .target(name: "SDGCommandLine", dependencies: [
            .productItem(name: "SDGCornerstone", package: "SDGCornerstone"),
            ]),
        .testTarget(name: "SDGCommandLineTests", dependencies: ["SDGCommandLine"])
    ]
)
