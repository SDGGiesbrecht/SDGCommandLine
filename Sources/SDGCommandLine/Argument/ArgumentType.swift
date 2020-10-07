/*
 ArgumentType.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

import SDGControlFlow
import SDGCollections
import SDGText
import SDGLocalization
import SDGVersioning

import SDGSwift

import SDGCommandLineLocalizations

/// A standard argument type provided by SDGCommandLine.
public enum ArgumentType {

  private static func keyOnly(
    _ key: StrictString
  ) -> UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ _ in
      return key
    })
  }
  private static let unused = UserFacing<StrictString, InterfaceLocalization>({ _ in
    unreachable()
  })

  internal static let booleanIdentifier: StrictString = "Boolean"
  /// A Boolean flag.
  public static let boolean: ArgumentTypeDefinition<Bool> = ArgumentTypeDefinition(
    name: keyOnly(ArgumentType.booleanIdentifier),
    syntaxDescription: unused,
    parse: { (_) -> Bool? in
      unreachable()
    }
  )

  private static let stringName = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "string"
    case .deutschDeutschland:
      return "Zeichenkette"
    }
  })

  private static let stringDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "An arbitrary string."
      case .deutschDeutschland:
        return "Eine beliebige Zeichenkette."
      }
    })

  /// An argument type that accepts arbitrary strings.
  public static let string: ArgumentTypeDefinition<StrictString> = ArgumentTypeDefinition(
    name: stringName,
    syntaxDescription: stringDescription,
    parse: { (argument: StrictString) -> StrictString? in
      return argument
    }
  )

  private static func enumerationSyntax<L: InputLocalization>(
    labels: [UserFacing<StrictString, L>]
  ) -> UserFacing<StrictString, InterfaceLocalization> {

    return UserFacing<StrictString, InterfaceLocalization>({ localization in

      let openingQuotationMark: StrictString
      let closingQuotationMark: StrictString
      switch localization {
      case .englishUnitedKingdom:
        openingQuotationMark = "‘"
        closingQuotationMark = "’"
      case .englishUnitedStates, .englishCanada:
        openingQuotationMark = "“"
        closingQuotationMark = "”"
      case .deutschDeutschland:
        openingQuotationMark = "„"
        closingQuotationMark = "“"
      }

      let comma: StrictString
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        comma = ", "
      }

      let or: StrictString
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        or = " or "
      case .deutschDeutschland:
        or = " oder "
      }

      let period: StrictString
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        period = "."
      }

      let list = labels.map({ openingQuotationMark + $0.resolved() + closingQuotationMark })
        .sorted()
      var result = StrictString(list.dropLast().joined(separator: comma))
      result.append(contentsOf: or + list.last! + period)
      return result

    })
  }

  /// Creates an enumeration argument type.
  ///
  /// - Parameters:
  ///     - name: The name of the option.
  ///     - cases: An array of enumeration options. Specify each option as a tuple containing the option’s name (for the command line) and the option’s value (for within Swift).
  ///     - value: The value of the enumeration case.
  ///     - label: The label for the enumeration case.
  public static func enumeration<T, N: InputLocalization, L: InputLocalization>(
    name: UserFacing<StrictString, N>,
    cases: [(value: T, label: UserFacing<StrictString, L>)]
  ) -> ArgumentTypeDefinition<T> {

    var syntaxLabels: [UserFacing<StrictString, L>] = []
    var entries: [StrictString: T] = [:]
    for option in cases {
      syntaxLabels.append(option.label)
      for key in Command.list(names: option.label) {
        entries[key] = option.value
      }
    }

    return ArgumentTypeDefinition(
      name: name,
      syntaxDescription: enumerationSyntax(labels: syntaxLabels),
      parse: { (argument: StrictString) -> T? in
        return entries[argument]
      }
    )
  }

  private static func integerName(range: CountableClosedRange<Int>) -> UserFacing<
    StrictString, InterfaceLocalization
  > {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "\(range.lowerBound.inDigits())–\(range.upperBound.inDigits())"
      }
    })
  }

  private static func integerDescription(range: CountableClosedRange<Int>) -> UserFacing<
    StrictString, InterfaceLocalization
  > {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return
          "An integer between \(range.lowerBound.inDigits()) and \(range.upperBound.inDigits()) inclusive."
      case .deutschDeutschland:
        return
          "Eine ganze Zahl zwischen \(range.lowerBound.inDigits()) und \(range.upperBound.inDigits()) einschließlich."
      }
    })
  }

  private static var cache: [CountableClosedRange<Int>: ArgumentTypeDefinition<Int>] = [:]
  /// An argument type representing an integer in a specific range.
  ///
  /// - Parameters:
  ///     - range: The valid range for the argument.
  public static func integer(in range: CountableClosedRange<Int>) -> ArgumentTypeDefinition<Int> {
    return cached(in: &cache[range]) {
      return ArgumentTypeDefinition(
        name: integerName(range: range),
        syntaxDescription: integerDescription(range: range),
        parse: { (argument: StrictString) -> Int? in

          if let integer = try? Int.parse(possibleDecimal: argument).get(),
            integer ∈ range
          {
            return integer
          } else {
            return nil
          }
        }
      )  // @exempt(from: tests)
    }
  }

  private static let pathName = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "path"
    case .deutschDeutschland:
      return "Pfad"
    }
  })  // @exempt(from: tests) Meaningless region.

  private static let pathDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom:
        return
          "A file system path. The form ‘/...’ indicates an absolute path. The form ‘~/...’ indicates a path relative to the home directory. Anything else is interpreted relative to the current working directory."
      case .englishUnitedStates, .englishCanada:
        return
          "A file system path. The form “/...” indicates an absolute path. The form “~/...” indicates a path relative to the home directory. Anything else is interpreted relative to the current working directory."
      case .deutschDeutschland:
        return
          "Ein Pfadname. Die Form „/...“ gibt einen vollständigen Pfad an. Die Form „~/...“ gibt einen relativen Pfad an, ausgehend von dem Benutzerverzeichnis. Alles andere gilt als relativer Pfad, ausgehened vom aktuellen Arbeitsverzeichnis."
      }
    })

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// An argument type representing a file system path.
    public static let path: ArgumentTypeDefinition<URL> = ArgumentTypeDefinition(
      name: pathName,
      syntaxDescription: pathDescription,
      parse: { (argument: StrictString) -> URL? in

        if argument.hasPrefix("/") {
          return URL(fileURLWithPath: String(argument))
        } else if argument == "~" {
          return URL(fileURLWithPath: NSHomeDirectory())
        } else if argument.hasPrefix("~/") {
          let home = URL(fileURLWithPath: NSHomeDirectory())
          let dropped = String(StrictString(argument.dropFirst(2)))
          if dropped.isEmpty {
            return home
          } else {
            return home.appendingPathComponent(dropped)
          }
        } else {
          return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(String(argument))
        }
      }
    )  // @exempt(from: tests) Meaningless region.
  #endif

  private static let languagePreferenceName = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "language preference"
      case .deutschDeutschland:
        return "Spracheinstellung"
      }
    })

  private static let languagePreferenceDescription = UserFacing<
    StrictString, InterfaceLocalization
  >({ localization in
    switch localization {
    case .englishUnitedKingdom:
      return
        "A list of IETF language tags or language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: ‘en\u{2D}GB’ or ‘🇬🇧EN’ → British English, ‘cy,en;fr’ → both Welsh and English, otherwise French"
    case .englishUnitedStates:
      return
        "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}US” or “🇺🇸EN” → American English, “nv,en;es” → both Navajo and English, otherwise Spanish"
    case .englishCanada:
      return
        "A list of IETF language tags or SDGCornerstone language icons. Semicolons indicate fallback order. Commas indicate that multiple languages should be used. Examples: “en\u{2D}CA” or “🇨🇦EN” → Canadian English, “cwd,en;fr” → both Woods Cree and English, otherwise French"
    case .deutschDeutschland:
      return
        "Eine Liste IETF Sprachbezeichnungen oder SDGCornerstone‐Sprachsymbole. Doppelpunkte geben die Ersatzreihenfolge an. Kommata geben an, dass mehrere Sprachen verwendet werden sollen. Beispiele: „de\u{2D}DE“ oder „🇩🇪DE“ → Deutsch aus Deutschland, “bar,de;fr” → beide Bairisch und Deutsch, sonst Französisch"
    }
  })

  /// An argument type representing a language preference.
  public static let languagePreference: ArgumentTypeDefinition<LocalizationSetting> =
    ArgumentTypeDefinition(
      name: languagePreferenceName,
      syntaxDescription: languagePreferenceDescription,
      parse: { (argument: StrictString) -> LocalizationSetting? in

        let groups = argument.components(
          separatedBy: ConditionalPattern({ $0 ∈ Set<UnicodeScalar>([";", "·"]) })
        ).map({ StrictString($0.contents) })
        let languages = groups.map({
          $0.components(separatedBy: [","])
            .map({ (component: PatternMatch<StrictString>) -> String in

              let iconOrCode = StrictString(component.contents)
              if let code = InterfaceLocalization.code(for: iconOrCode) {
                return code
              } else {
                return String(iconOrCode)
              }
            })
        })  // @exempt(from: tests) Meaningless region.
        return LocalizationSetting(orderOfPrecedence: languages)
      }
    )

  private static let versionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "version"
    case .deutschDeutschland:
      return "Version"
    }
  })

  private static let developmentCase = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "development"
      case .deutschDeutschland:
        return "entwicklung"
      }
    })

  private static let versionDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      let development = ArgumentType.developmentCase.resolved(for: localization)
      switch localization {
      case .englishUnitedKingdom:
        return "A version number or ‘\(development)’."
      case .englishUnitedStates, .englishCanada:
        return "A version number or “\(development)”."
      case .deutschDeutschland:
        return "Eine Versionsnummer oder „\(development)“."
      }
    })

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    internal static let version: ArgumentTypeDefinition<Build> = ArgumentTypeDefinition(
      name: versionName,
      syntaxDescription: versionDescription,
      parse: { (argument: StrictString) -> Build? in

        if let version = Version(String(argument)) {
          return Build.version(version)
        } else {
          for localization in InterfaceLocalization.allCases {
            if argument == ArgumentType.developmentCase.resolved(for: localization) {
              return Build.development
            }
          }
          return nil
        }
      }
    )  // @exempt(from: tests)
  #endif
}
