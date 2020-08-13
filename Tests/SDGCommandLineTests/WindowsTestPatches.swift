/*
 WindowsTestPatches.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if os(Windows)
  import SDGText
  import SDGLocalization

  // #workaround(SDGCornerstone 5.4.1, Original causes segmentation fault.)
  func testCustomStringConvertibleConformance<T, L>(
    of instance: T,
    localizations: L.Type,
    uniqueTestName: StrictString,
    overwriteSpecificationInsteadOfFailing: Bool,
    file: StaticString = #file,
    line: UInt = #line
  ) where T: CustomStringConvertible, L: InputLocalization {}
#endif
