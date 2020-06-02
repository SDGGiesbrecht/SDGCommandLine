/*
 Build.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

import SDGSwift

extension Build {

  // MARK: - Static Properties

  // #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    internal static let current: Build? = {
      guard let versionNumber = ProcessInfo.version else {
        return nil  // @exempt(from: tests)
      }
      return .version(versionNumber)
    }()
  #endif
}
