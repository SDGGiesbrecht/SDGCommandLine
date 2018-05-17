/*
 ExportInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLineLocalizations

extension Command {

    private static let exportInterfaceName = UserFacing<StrictString, InterfaceLocalization>({ _ in return "export‐interface" })

    private static let exportInterfaceDescription = UserFacing<StrictString, InterfaceLocalization>({ _ in
        "exports the interface in a machine readable format."
    })

    internal static let exportInterface = Command(name: exportInterfaceName, description: exportInterfaceDescription, directArguments: [], options: [], hidden: true, execution: { (_, _, output: Command.Output) throws -> Void in

        let stack = Command.stack.dropLast() // Ignoring export‐interface.
        let command = stack.last!

        let encoder = JSONEncoder()
        encoder.outputFormatting.insert(.prettyPrinted)
        if #available(OSX 10.13, *) { // [_Exempt from Test Coverage_]
            encoder.outputFormatting.insert(.sortedKeys)
        }
        let data = try encoder.encode(command)
        output.print(try String(file: data, origin: nil))
    })
}