/*
 Error.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if os(WASI)
  extension Error {

    // #workaround(Swift 5.2.4, Web is missing this property.)
    internal var localizedDescription: String {
      return String(describing: self)
    }
  }
#endif
