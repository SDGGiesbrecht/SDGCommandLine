/*
 FontWeight.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2023 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A font weight.
public enum FontWeight: Int, TextFormat {

  /// Bold.
  case bold = 1

  /// Light.
  case light = 2

  // MARK: - TextFormat

  public var startCode: Int {
    return rawValue
  }

  public static var resetCode: Int { 22 }
}
