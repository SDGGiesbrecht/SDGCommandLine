/*
 VersionSubcommand.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization

import SDGCommandLineLocalizations

extension Command {

    private static let versionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "version"
        }
    })

    private static let versionDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "displays the version in use."
        }
    })

    internal static let version = Command(name: versionName, description: versionDescription, directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws -> Void in

        if let stable = ProcessInfo.version {
            output.print(stable.string())
        } else {
            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Not a stable version."
                }
            }).resolved())
        }
    })
}
