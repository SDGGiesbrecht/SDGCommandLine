/*
 Language.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

enum Language : String, InputLocalization {

    // MARK: - Cases

    case english = "en"
    case deutsch = "de"
    case unsupported = "zxx"
    internal static let cases: [Language] = [.english, .deutsch, .unsupported]

    // MARK: - Localization

    internal static let fallbackLocalization: Language = .english
}
