/*
 Options.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGText
import SDGLocalization

import SDGCommandLineLocalizations

/// Parsed options.
public struct Options: TransparentWrapper {

  // MARK: - Static Properties

  private static let noColourName = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishCanada:
        return "no‐colour"
      case .englishUnitedStates:
        return "no‐color"
      case .deutschDeutschland:
        return "ohne‐farben"
      }
    })

  private static let noColourDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishCanada:
        return "Removes colour from the output."
      case .englishUnitedStates:
        return "Removes color from the output."
      case .deutschDeutschland:
        return "Blendet Farben aus der Ausgabe aus."
      }
    })

  internal static let noColour = Option(
    name: noColourName,
    description: noColourDescription,
    type: ArgumentType.boolean
  )

  private static let languageName = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "language"
      case .deutschDeutschland:
        return "sprache"
      }
    })

  private static let languageDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "A language to use instead of the one specified in preferences."
      case .deutschDeutschland:
        return "Eine Sprache anstelle deren zu verwenden, die in den Einstellungen angegeben ist."
      }
    })

  internal static let language = Option(
    name: languageName,
    description: languageDescription,
    type: ArgumentType.languagePreference
  )

  internal static let useVersionName = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "use‐version"
      case .deutschDeutschland:
        return "version‐verwenden"
      }
    })

  private static let useVersionDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return
          "Attempts to download and temporarily use the specified version insead of the one which is installed."
      case .deutschDeutschland:
        return
          "Versucht die angegebene Version herunterzuladen und vorübergehend anstelle deren zu verwenden, die installiert ist."
      }
    })

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    internal static let useVersion = Option(
      name: useVersionName,
      description: useVersionDescription,
      type: ArgumentType.version
    )
  #endif

  // MARK: - Initialization

  internal init() {}

  // MARK: - Properties

  private var options: [StrictString: Any] = [:]

  // MARK: - Usage

  internal mutating func add(value: Any, for option: AnyOption) {
    options[option.identifier] = value
  }

  /// Returns the value of the specified option, or `nil` if the option is not defined.
  ///
  /// - Parameters:
  ///     - option: The option to check.
  public func value<T>(for option: Option<T>) -> T? {
    return options[option.identifier] as? T
  }

  /// Returns `true` if the Boolean flag is active and `false` if it is not.
  ///
  /// - Parameters:
  ///     - option: The option to check.
  public func value(for option: Option<Bool>) -> Bool {
    return (options[option.identifier] as? Bool) == true
  }

  // MARK: - TransparentWrapper

  public var wrappedInstance: Any {
    return options
  }
}
