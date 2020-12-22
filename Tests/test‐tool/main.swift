/*
 main.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGCommandLine

import TestTool

// #workaround(Swift 5.3.2, Web lacks ProcessInfo.)
#if !os(WASI)
  ProcessInfo.applicationIdentifier = "ca.solideogloria.SDGCommandLine.test‐tool"
  ProcessInfo.version = nil
  ProcessInfo.packageURL = nil
#endif

Tool.command.executeAsMain()
