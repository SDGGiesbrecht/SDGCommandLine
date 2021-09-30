/*
 Int.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2021 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
import SDGText
import SDGLocalization

extension Int {

  // #workaround(SDGCornerstone 7.2.3, This is redundant, but dodges a compiler bug.)
  internal static func parse(
    possibleDecimal decimal: StrictString
  ) -> Result<Self, TextConvertibleNumberParseError> {
    var negative = false
    var string = decimal
    if decimal.first == "−" {
      negative = true
      string.removeFirst()
    }
    return parse(decimal, base: 10).map { result in
      if negative {
        return -result  // @exempt(from: unicode)
      } else {
        return result
      }
    }
  }
}
