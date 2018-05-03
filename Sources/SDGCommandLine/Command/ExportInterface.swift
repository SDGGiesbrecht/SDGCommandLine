/*
 ExportInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLineLocalizations

extension Command {

    private static let exportInterfaceName = UserFacing<StrictString, InterfaceLocalization>({ _ in return "export‐interface" })

    private static let exportInterfaceDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        "exports the interface in a machine readable format."
    })

    internal static let exportInterface = Command(name: exportInterfaceName, description: exportInterfaceDescription, directArguments: [], options: [], hidden: true, execution: { (_, _, output: Command.Output) throws -> Void in
        print("Exporting...") // [_Warning: Not yet implemented._]
    })
}
