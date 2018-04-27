/*
 PackageRepository.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLineLocalizations

// [_Warning: Temporary_]
import SDGSwift
import SDGSwiftPackageManager

/// :nodoc: (Shared to Workspace.)
extension PackageRepository {

    // MARK: - Actions

    internal func buildForRelease(output: Command.Output) throws -> URL {
        try build(reportProgress: { output.print($0) })
        return releaseProductsDirectory()
    }
}
