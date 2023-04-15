/*
 Language.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2023 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGCommandLine

public enum Language: String, InputLocalization {

  // MARK: - Cases

  case english = "en"
  case deutsch = "de"
  case unsupported = "zxx"
  public static let cases: [Language] = [.english, .deutsch, .unsupported]

  // MARK: - Localization

  public static let fallbackLocalization: Language = .english
}
