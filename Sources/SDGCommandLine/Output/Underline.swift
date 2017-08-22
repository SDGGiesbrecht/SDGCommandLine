/*
 Underline.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An underline.
public enum Underline : Int, TextFormat {

    /// Underlined.
    case underlined = 4

    // MARK: - TextFormat

    // [_Inhert Documentation: SDGCommandLine.TextFormat.startCode_]
    /// The ANSI start code.
    public var startCode: Int {
        return rawValue
    }

    // [_Inherit Documentation: SDGCommandLine.TextFormat.resetCode_]
    /// The ANSI reset code.
    public static let resetCode = 24
}
