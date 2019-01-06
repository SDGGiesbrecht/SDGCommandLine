/*
 FontWeight.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A font weight.
public enum FontWeight : Int, TextFormat {

    /// Bold.
    case bold = 1

    /// Light.
    case light = 2

    // MARK: - TextFormat

    // [_Inhert Documentation: SDGCommandLine.TextFormat.startCode_]
    /// The ANSI start code.
    public var startCode: Int {
        return rawValue
    }

    // #documentation(SDGCommandLine.TextFormat.resetCode)
    /// The ANSI reset code.
    public static let resetCode: Int = 22
}
