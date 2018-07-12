/*
 Colour.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A font colour.
public enum Colour : Int, TextFormat {

    /// Black.
    case black = 30

    /// Grey.
    case grey = 90

    /// Light grey.
    case lightGrey = 37

    /// White.
    case white = 97

    /// Red.
    case red = 31

    /// Bright red.
    case brightRed = 91

    /// Yellow.
    case yellow = 33

    /// Bright yellow.
    case brightYellow = 93

    /// Green.
    case green = 32

    /// Bright green.
    case brightGreen = 92

    /// Cyan.
    case cyan = 36

    /// Bright cyan.
    case brightCyan = 96

    /// Blue.
    case blue = 34

    /// Bright blue.
    case brightBlue = 94

    /// Magenta.
    case magenta = 35

    /// Bright magenta.
    case brightMagenta = 95

    // MARK: - TextFormat

    // [_Inhert Documentation: SDGCommandLine.TextFormat.startCode_]
    /// The ANSI start code.
    public var startCode: Int {
        return rawValue
    }

    // #documentation(SDGCommandLine.TextFormat.resetCode)
    /// The ANSI reset code.
    public static let resetCode = 39
}
