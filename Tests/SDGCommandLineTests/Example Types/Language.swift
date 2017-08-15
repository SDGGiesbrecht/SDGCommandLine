/*
 Language.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

internal enum Language : String, InputLocalization {

    // MARK: - Cases

    case english = "en"
    case deutsch = "de"
    internal static let cases: [Language] = [.english, .deutsch]

    // MARK: - Localization

    internal static let fallbackLocalization: Language = .english
}
