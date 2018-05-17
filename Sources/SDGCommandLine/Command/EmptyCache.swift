/*
 EmptyCache.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import SDGCommandLineLocalizations

extension Command {

    private static let emptyCacheName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "empty‐cache"
        }
    })

    private static let emptyCacheDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "removes any cached data."
        }
    })

    internal static let emptyCache = Command(name: emptyCacheName, description: emptyCacheDescription, directArguments: [], options: [], execution: { _, _, _ in

        if ProcessInfo.possibleApplicationIdentifier ≠ nil {
            // Otherwise it would crash.
            // But nothing could have been cached anyway.
            FileManager.default.delete(.cache)
        }
    })
}