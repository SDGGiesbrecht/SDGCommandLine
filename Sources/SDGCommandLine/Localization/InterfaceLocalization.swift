/*
 InterfaceLocalization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal enum InterfaceLocalization : String, InputLocalization {

    // MARK: - Cases

    case englishUnitedKingdom = "en\u{2D}GB"
    case englishUnitedStates = "en\u{2D}US"
    case englishCanada = "en\u{2D}CA"

    internal static let cases: [InterfaceLocalization] = [

        .englishUnitedKingdom,
        .englishUnitedStates,
        .englishCanada,
    ]

    // MARK: - Localization

    internal static let fallbackLocalization: InterfaceLocalization = .englishUnitedKingdom
}
