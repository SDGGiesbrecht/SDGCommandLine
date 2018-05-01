/*
 Build.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwift

extension Build {

    // MARK: - Static Properties

    internal static let current: Build? = {
        guard let versionNumber = ProcessInfo.version else {
            return nil
        }
        return .version(versionNumber)
    }()
}
