// swift-tools-version:3.1

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

let package = Package(
    name: "SDGCommandLine",
    dependencies: [
        .Package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", versions: Version(0, 4, 4) ..< Version(0, 5, 0))
    ]
)
