/*
 Underline.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An underline.
public enum Underline : Int, TextFormat {

    /// Underlined.
    case underlined = 4

    // MARK: - TextFormat

    public var startCode: Int {
        return rawValue
    }

    public static let resetCode: Int = 24
}
