/*
 StringFamily.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import SDGText

extension StringFamily {

  // MARK: - Semantic Formatting

  /// Returns the string formatted as a section header.
  public func formattedAsSectionHeader() -> Self {
    return self.in(FontWeight.bold).in(Colour.blue).separated()
  }

  /// Returns the string formatted as an error.
  public func formattedAsError() -> Self {
    return self.in(FontWeight.bold).in(Colour.red)
  }

  /// Returns the string formatted as a warning.
  public func formattedAsWarning() -> Self {
    return self.in(FontWeight.bold).in(Colour.yellow)
  }

  /// Returns the string formatted to indicate success.
  public func formattedAsSuccess() -> Self {
    return self.in(FontWeight.bold).in(Colour.green)
  }

  // MARK: - General Formatting

  private static var escape: UnicodeScalar {
    return "\u{1B}"
  }
  private static var endOfCode: UnicodeScalar {
    return "m"
  }

  /// Returns a string formed by applying the specified format to the entire string.
  ///
  /// - Parameters:
  ///     - format: The format to apply.
  public func `in`(_ format: TextFormat) -> Self {

    func apply(code: Int) -> String {
      return "\(Self.escape)[\(code)\(Self.endOfCode)"
    }

    var copy = self
    copy.scalars.prepend(contentsOf: apply(code: format.startCode).scalars)
    copy.scalars.append(contentsOf: apply(code: type(of: format).resetCode).scalars)
    return copy
  }

  /// Returns a string formed by applying empty lines above and below.
  public func separated() -> Self {
    var copy = self
    copy.scalars.prepend("\n")
    copy.scalars.append("\n")
    return copy
  }

  internal mutating func removeCommandLineFormatting() {
    let escape = [Self.escape].literal(for: ScalarView.self)
    let any = RepetitionPattern(
      ConditionalPattern<ScalarView>({ _ in true }),
      consumption: .lazy
    )
    scalars.replaceMatches(
      for: escape
        + any
        + [Self.endOfCode].literal(for: ScalarView.self),
      with: []
    )
  }

  // MARK: - Help

  internal func formattedAsSubcommand() -> Self {
    return self.in(FontWeight.bold).in(Colour.green)
  }

  internal func formattedAsOption() -> Self {
    return self.in(FontWeight.bold).in(Colour.cyan)
  }

  internal func formattedAsType() -> Self {
    return self.in(Colour.cyan)
  }
}
