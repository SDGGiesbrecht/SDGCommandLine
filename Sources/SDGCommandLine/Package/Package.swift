/*
 Package.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections
import SDGText
import SDGExternalProcess

import SDGSwift

extension Package {

  #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
    // MARK: - Static Properties

    private static let versionsCache = FileManager.default.url(in: .cache, at: "Versions")

    // MARK: - Usage

    #if !PLATFORM_LACKS_FOUNDATION_PROCESS
      internal func execute(
        _ version: Build,
        of executableNames: Set<StrictString>,
        with arguments: [StrictString],
        output: Command.Output
      ) throws {
        _ = try execute(
          version,
          of: executableNames,
          with: arguments.map({ String($0) }),
          cacheDirectory: Package.versionsCache,
          reportProgress: { output.print($0) }
        ).get()
      }
    #endif
  #endif
}
