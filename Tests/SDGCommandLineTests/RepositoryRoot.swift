/*
 RepositoryRoot.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

let repositoryRoot: URL = {
  var result = URL(fileURLWithPath: #filePath)
  for _ in 1...3 {
    result.deleteLastPathComponent()
  }
  return result
}()
