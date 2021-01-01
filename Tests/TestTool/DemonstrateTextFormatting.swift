/*
 DemonstrateTextFormatting.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2021 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

internal enum DemonstrateTextFormatting {

  internal static let command = Command(
    name: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrate‐text‐formatting"
      case .deutsch:
        return "textgestaltung‐vorführen"
      }
    }),
    description: UserFacing<StrictString, Language>({ localization in
      switch localization {
      case .english, .unsupported:
        return "demonstrates text formatting."
      case .deutsch:
        return "führt Textgestaltung vor."
      }
    }),
    directArguments: [],
    options: [],
    execution: { (_, _, output: Command.Output) throws -> Void in

      output.print("Header".formattedAsSectionHeader())
      output.print("Error".formattedAsError())
      output.print("Warning".formattedAsWarning())
      output.print("Success".formattedAsSuccess())

      output.print("Normal")
      output.print("Bold".in(FontWeight.bold))
      output.print("Light".in(FontWeight.light))
      output.print("Normal")

      output.print("Underlined \("Bold".in(FontWeight.bold)) Underlined".in(Underline.underlined))

      output.print("Black".in(Colour.black))
      output.print("Grey".in(Colour.grey))
      output.print("Light Grey".in(Colour.lightGrey))
      output.print("White".in(Colour.white))
      output.print("Red".in(Colour.red))
      output.print("Bright Red".in(Colour.brightRed))
      output.print("Yellow".in(Colour.yellow))
      output.print("Bright Yellow".in(Colour.brightYellow))
      output.print("Green".in(Colour.green))
      output.print("Bright Green".in(Colour.brightGreen))
      output.print("Cyan".in(Colour.cyan))
      output.print("Bright Cyan".in(Colour.brightCyan))
      output.print("Blue".in(Colour.blue))
      output.print("Bright Blue".in(Colour.brightBlue))
      output.print("Magenta".in(Colour.magenta))
      output.print("Bright Magenta".in(Colour.brightMagenta))

      output.print("Normal")
    }
  )
}
