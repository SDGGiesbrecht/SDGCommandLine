/*
 TextFormat.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A element of text formatting.
public protocol TextFormat {

  /// The ANSI start code.
  var startCode: Int { get }

  /// The ANSI reset code.
  static var resetCode: Int { get }
}
