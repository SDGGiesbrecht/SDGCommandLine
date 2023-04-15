/*
 SystemLocalization.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2018–2023 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

public enum SystemLocalization: String, CaseIterable, InputLocalization {

  // MARK: - Cases

  case 普通话中国 = "cmn\u{2D}Hans\u{2D}CN"
  case 國語中國 = "cmn\u{2D}Hant\u{2D}TW"

  case españolEspaña = "es\u{2D}ES"

  case englishUnitedKingdom = "en\u{2D}GB"
  case englishUnitedStates = "en\u{2D}US"
  case englishCanada = "en\u{2D}CA"

  case العربية_السعودية = "arb\u{2D}SA"

  case हिन्दी_भारत = "hi\u{2D}IN"

  case portuguêsPortugal = "pt\u{2D}PT"

  case русскийРоссия = "ru\u{2D}RU"

  case 日本語日本国 = "ja\u{2D}JP"

  case deutschDeutschland = "de\u{2D}DE"

  case tiếngViệtViệtNam = "vi\u{2D}VN"

  case 한국어한국 = "ko\u{2D}KR"

  case françaisFrance = "fr\u{2D}FR"

  case türkçeTürkiye = "tr\u{2D}TR"

  case italianoItalia = "it\u{2D}IT"

  case polskiPolska = "pl\u{2D}PL"

  case українськаУкраїна = "uk\u{2D}UA"

  case nederlandsNederland = "nl\u{2D}NL"

  case malaysiaMalaysia = "zsm\u{2D}MY"

  case românăRomânia = "ro\u{2D}RO"

  case ไทยไทย = "th\u{2D}TH"

  case ελληνικάΕλλάδα = "el\u{2D}GR"

  case češtinaČesko = "cs\u{2D}CZ"

  case magyarMagyarország = "hu\u{2D}HU"

  case svenskaSverige = "sv\u{2D}SE"

  case indonesiaIndonesia = "id\u{2D}ID"

  case danskDanmark = "da\u{2D}DK"

  case suomiSuomi = "fi\u{2D}FI"

  case slovenčinaSlovensko = "sk\u{2D}SK"

  case עברית־ישראל = "he\u{2D}IL"

  case norskNorge = "nb\u{2D}NO"

  case hrvatskiHrvatska = "hr\u{2D}HR"

  case catalàEspanya = "ca\u{2D}ES"

  // MARK: - Localization

  public static let fallbackLocalization: SystemLocalization = .עברית־ישראל
}
