/*
 SDGCornerstone.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

// [_Workaround: Pending SDGCornerstone updates. (SDGCornerstone 0.4.3)_]

extension FileManager {
    public func `do`(in directory: URL, closure: () throws -> Void) throws {

        try createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)

        let previous = currentDirectoryPath
        changeCurrentDirectoryPath(directory.path)
        defer { changeCurrentDirectoryPath(previous) }

        try closure()
    }
}
