/*
 APILocalization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

public enum APILocalization : String, CaseIterable, InputLocalization {

    // MARK: - Cases

    case englishCanada = "en\u{2D}CA"

    // #workaround(SDGCornerstone 0.11.1, This may not be necessary once InputLocalization is refactored around CaseIterable.)
    public static let cases: [APILocalization] = allCases

    // MARK: - Localization

    public static let fallbackLocalization: APILocalization = .englishCanada
}
