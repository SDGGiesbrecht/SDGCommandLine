/*
 SDGCornerstone.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Workaround: This belongs in SDGCornerstone. (SDGCornerstone 0.9.2)_]

extension ClosedRange : Hashable where Bound : Hashable {

    /// :nodoc:
    public var hashValue: Int {
        return upperBound.hashValue
    }
}
