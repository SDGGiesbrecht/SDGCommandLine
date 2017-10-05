// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

let library = "SDGCommandLine"
let tests = library + "Tests"

let sdgGiesbrecht = "https://github.com/SDGGiesbrecht/"
let sdgCornerstone = "SDGCornerstone"

let package = Package(
    name: library,
    products: [
        .library(name: library, targets: [library])
    ],
    dependencies: [
        .package(url: sdgGiesbrecht + sdgCornerstone, from: Version(0, 5, 0))
    ],
    targets: [
        .target(name: library, dependencies: [
            .productItem(name: sdgCornerstone, package: sdgCornerstone)
            ]),
        .testTarget(name: tests, dependencies: [.targetItem(name: library)])
    ]
)
