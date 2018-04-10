/*
 DemonstrateTextFormatting.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

enum DemonstrateTextFormatting {

    static let command = Command(name: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "demonstrate‐text‐formatting"
        case .deutsch:
            return "textgestaltung‐vorführen"
        }
    }), description: UserFacingText({ (localization: Language) -> StrictString in
        switch localization {
        case .english, .unsupported:
            return "demonstrates text formatting."
        case .deutsch:
            return "führt Textgestaltung vor."
        }
    }), directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws -> Void in

        print("Header".formattedAsSectionHeader(), to: &output)
        print("Error".formattedAsError(), to: &output)
        print("Warning".formattedAsWarning(), to: &output)
        print("Success".formattedAsSuccess(), to: &output)

        print("Normal", to: &output)
        print("Bold".in(FontWeight.bold), to: &output)
        print("Light".in(FontWeight.light), to: &output)
        print("Normal", to: &output)

        print("Underlined \("Bold".in(FontWeight.bold)) Underlined".in(Underline.underlined), to: &output)

        print("Black".in(Colour.black), to: &output)
        print("Grey".in(Colour.grey), to: &output)
        print("Light Grey".in(Colour.lightGrey), to: &output)
        print("White".in(Colour.white), to: &output)
        print("Red".in(Colour.red), to: &output)
        print("Bright Red".in(Colour.brightRed), to: &output)
        print("Yellow".in(Colour.yellow), to: &output)
        print("Bright Yellow".in(Colour.brightYellow), to: &output)
        print("Green".in(Colour.green), to: &output)
        print("Bright Green".in(Colour.brightGreen), to: &output)
        print("Cyan".in(Colour.cyan), to: &output)
        print("Bright Cyan".in(Colour.brightCyan), to: &output)
        print("Blue".in(Colour.blue), to: &output)
        print("Bright Blue".in(Colour.brightBlue), to: &output)
        print("Magenta".in(Colour.magenta), to: &output)
        print("Bright Magenta".in(Colour.brightMagenta), to: &output)

        print("Normal", to: &output)
    })
}
