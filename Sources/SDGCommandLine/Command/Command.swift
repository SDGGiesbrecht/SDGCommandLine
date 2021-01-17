/*
 Command.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2021 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGLogic
import SDGMathematics
import SDGCollections
import SDGText
import SDGLocalization

import SDGSwift

import SDGCommandLineLocalizations

/// A command.
public struct Command: Encodable, TextualPlaygroundDisplay {

  // MARK: - Static Properties

  private static var standardOptions: [AnyOption] {
    var options: [AnyOption] = [
      Options.noColour,
      Options.language,
    ]
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO && !PLATFORM_LACKS_FOUNDATION_PROCESS
      if ProcessInfo.packageURL ≠ nil {
        options.append(Options.useVersion)
      }
    #endif
    return options
  }

  // MARK: - Initialization

  /// Creates a command.
  ///
  /// - Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
  ///
  /// - Parameters:
  ///     - name: The name.
  ///     - description: A brief description. (Printed by the `help` subcommand.)
  ///     - discussion: Optional. Additional in‐depth information. (Printed by the `help` subcommand.)
  ///     - directArguments: A list of direct command line arguments to accept.
  ///     - options: A list of command line options to accept.
  ///     - hidden: Optional. Set to `true` to hide the command from the “help” lists.
  ///     - execution: A closure to run for the command’s execution. The closure should indicate success by merely returning, and failure by throwing an instance of `Command.Error`. (Do not call `exit()` or other `Never`‐returning functions.)
  ///     - parsedDirectArguments: The parsed direct arguments.
  ///     - parsedOptions: The parsed options.
  ///     - output: The stream for standard output. Use `output.print(...)` for everything intendend for standard output. Anything printed by other means will not be filtered by `•no‐colour`, not be captured for the return value of `execute()` and not be available to any other specialized handling.
  public init<N: InputLocalization, D: Localization>(
    name: UserFacing<StrictString, N>,
    description: UserFacing<StrictString, D>,
    discussion: UserFacing<StrictString, D>? = nil,
    directArguments: [AnyArgumentTypeDefinition],
    options: [AnyOption],
    hidden: Bool = false,
    execution: @escaping (
      _ parsedDirectArguments: DirectArguments,
      _ parsedOptions: Options,
      _ output: Command.Output
    ) throws -> Void
  ) {

    self.init(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: directArguments,
      options: options,
      hidden: hidden,
      execution: execution,
      subcommands: []
    )
  }

  /// Creates an umbrella command.
  ///
  /// - Warning: The main umbrella command should match the name of the executable module and be a single word with no spaces or hyphens. If it is localized, the package must also provide an identical executable module for each alternate name.
  ///
  /// - Parameters:
  ///     - name: The name.
  ///     - description: A brief description. (Printed by the `help` subcommand.)
  ///     - discussion: Optional. Additional in‐depth information. (Printed by the `help` subcommand.)
  ///     - subcommands: The subcommands.
  ///     - defaultSubcommand: The subcommand to execute if no subcommand is specified. (This should be an entry from `subcommands`.) Pass `nil` or leave this argument out to default to the help subcommand.
  ///     - hidden: Optional. Set to `true` to hide the command from the “help” lists.
  public init<N: InputLocalization, D: Localization>(
    name: UserFacing<StrictString, N>,
    description: UserFacing<StrictString, D>,
    discussion: UserFacing<StrictString, D>? = nil,
    subcommands: [Command],
    defaultSubcommand: Command? = nil,
    hidden: Bool = false
  ) {

    self.init(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: defaultSubcommand?.directArguments ?? [],
      options: defaultSubcommand?.options ?? [],
      hidden: hidden,
      execution: defaultSubcommand?.execution,
      subcommands: subcommands
    )
  }

  internal init<N: InputLocalization, D: Localization>(
    name: UserFacing<StrictString, N>,
    description: UserFacing<StrictString, D>,
    discussion: UserFacing<StrictString, D>?,
    directArguments: [AnyArgumentTypeDefinition],
    options: [AnyOption],
    hidden: Bool = false,
    execution: (
      (
        _ parsedDirectArguments: DirectArguments,
        _ parsedOptions: Options,
        _ output: Command.Output
      ) throws -> Void
    )?,
    subcommands: [Command] = [],
    addHelp: Bool = true
  ) {

    var actualSubcommands = subcommands

    if addHelp {
      actualSubcommands.append(Command.help)
    }

    localizedName = {
      return Command.normalizeToUnicode(
        name.resolved(),
        in: LocalizationSetting.current.value.resolved() as N
      )
    }
    names = Command.list(names: name)
    localizedDescription = { return description.resolved() }
    localizedDiscussion = { return discussion?.resolved() }
    self.isHidden = hidden
    self.identifier = Command.normalizeToUnicode(
      name.resolved(for: N.fallbackLocalization),
      in: N.fallbackLocalization
    )

    self.execution = execution ?? { _, _, _ in _ = try Command.help.execute(with: []).get() }
    self.subcommands = actualSubcommands
    self.directArguments = directArguments
    self.options = options.appending(
      contentsOf: Command.standardOptions.filter({ standard in
        return ¬options.contains(where: { option in
          return option.identifier == standard.identifier
        })
      })
    )
  }

  // MARK: - Properties

  internal private(set) static var stack: [Command] = []

  private let names: Set<StrictString>
  /// Returns the localized name of the command.
  public let localizedName: () -> StrictString
  internal let localizedDescription: () -> StrictString
  internal let localizedDiscussion: () -> StrictString?
  internal let isHidden: Bool
  internal let identifier: StrictString

  private let execution:
    (_ parsedDirectArguments: DirectArguments, _ parsedOptions: Options, _ output: Command.Output)
      throws -> Void
  internal var subcommands: [Command]
  internal let directArguments: [AnyArgumentTypeDefinition]
  internal let options: [AnyOption]

  // MARK: - Execution

  /// Returns the command modified to behave as though it is the root command of an executable.
  ///
  /// This method is available so that tests can get access to provided subcommands such as `empty‐cache`.
  ///
  /// - Warning: Calling this method before `executeAsMain()` is redundant. The result is undefined.
  public func withRootBehaviour() -> Command {
    var copy = self
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      copy.subcommands.append(contentsOf: [
        Command.version
      ])
    #endif
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      copy.subcommands.append(contentsOf: [
        Command.setLanguage,
        Command.emptyCache,
      ])
    #endif
    #if DEBUG
      copy.subcommands.append(Command.exportInterface)
    #endif
    return copy
  }

  /// Executes the command and exits.
  public func executeAsMain() -> Never {  // @exempt(from: tests) Not testable.

    let arguments = CommandLine.arguments.dropFirst().map { StrictString($0) }

    let exitCode: Int
    switch self.withRootBehaviour().execute(with: arguments) {
    case .success:
      exitCode = Error.successCode
    case .failure(let error):
      let errorDescription = error.presentableDescription().formattedAsError() + "\n"
      FileHandle.standardError.write(errorDescription.file)
      exitCode = error.exitCode
    }
    exit(Int32(truncatingIfNeeded: exitCode))
  }

  /// Executes the command without exiting.
  ///
  /// - Parameters:
  ///     - arguments: The command line arguments, including subcommands and options, to use. (The command itself should be left out.)
  ///     - output: Optional. An output instance to inherit from an encompassing command.
  ///
  /// - Returns: A result with one of the following values:
  ///     - `success`: The output. (For output to be captured properly, it must printed to the provided stream. See `init(name:execution:)`.)
  ///     - `failure`: A command error
  @discardableResult public func execute(
    with arguments: [StrictString],
    output: Command.Output? = nil
  ) -> Result<StrictString, Command.Error> {
    let outputCollector = output ?? Output()
    do {

      #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO && !PLATFORM_LACKS_FOUNDATION_PROCESS
        if let packageURL = ProcessInfo.packageURL {
          let versionAttempt = parseVersion(from: arguments)
          switch versionAttempt {
          case .failure(let error):
            return .failure(error)
          case .success(let parsedVersion):
            if let (version, otherArguments) = parsedVersion,
              version ≠ Build.current
            {

              let package = Package(url: packageURL)
              try package.execute(
                version,
                of: names,
                with: otherArguments,
                output: outputCollector
              )
              return .success(outputCollector.output)
            }
          }
        }
      #endif

      Command.stack.append(self)
      defer { Command.stack.removeLast() }

      if let first = arguments.first {
        for subcommand in subcommands where first ∈ subcommand.names {
          return subcommand.execute(with: Array(arguments.dropFirst()), output: outputCollector)
        }
      }

      let argumentsAttempt = parse(arguments: arguments)
      let directArguments: DirectArguments
      let options: Options
      switch argumentsAttempt {
      case .failure(let error):
        return .failure(error)
      case .success(let (parsedArguments, parsedOptions)):
        directArguments = parsedArguments
        options = parsedOptions
      }

      if options.value(for: Options.noColour) {
        outputCollector.filterFormatting = true
      }

      let language = options.value(for: Options.language) ?? LocalizationSetting.current.value
      try language.do {
        try execute(withArguments: directArguments, options: options, output: outputCollector)
      }
      return .success(outputCollector.output)

    } catch var error as Command.Error {
      error.output = outputCollector.output
      return .failure(error)
    } catch {
      var wrapped = Command.Error(wrapping: error)
      wrapped.output = outputCollector.output
      return .failure(wrapped)
    }
  }

  /// Executes the command without exiting.
  ///
  /// - Parameters:
  ///     - arguments: Parsed arguments.
  ///     - options: Parsed options.
  ///     - output: The output stream.
  public func execute(
    withArguments arguments: DirectArguments,
    options: Options,
    output: Command.Output
  ) throws {
    try purgingAutoreleased {
      try execution(arguments, options, output)
    }
  }

  // MARK: - Argument Parsing

  private func parse(
    arguments: [StrictString]
  ) -> Result<(DirectArguments, Options), Command.Error> {
    var directArguments = DirectArguments()
    var options = Options()

    var remaining: ArraySlice<StrictString> = arguments[arguments.bounds]
    var expected: ArraySlice<AnyArgumentTypeDefinition> = self.directArguments[
      self.directArguments.bounds
    ]
    while let argument = remaining.popFirst() {

      let optionAttempt = parse(
        possibleOption: argument,
        remainingArguments: &remaining,
        parsedOptions: &options
      )
      switch optionAttempt {
      case .failure(let error):
        return .failure(error)
      case .success(let isOption):
        if ¬isOption {
          let directArgumentAttempt = parse(
            possibleDirectArgument: argument,
            parsedDirectArguments: &directArguments,
            expectedDirectArguments: &expected
          )
          switch directArgumentAttempt {
          case .failure(let error):
            return .failure(error)
          case .success(let isDirectArgument):
            if ¬isDirectArgument {

              let commandStack = Command.stack  // Prevent delayed evaluation.
              return .failure(
                Command.Error(
                  description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    var result: StrictString
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                      result = "Unexpected argument: \(argument)"
                    case .deutschDeutschland:
                      result = "Unerwartetes Argument: \(argument)"
                    }
                    return result + "\n"
                      + Command.helpInstructions(for: commandStack).resolved(for: localization)
                  })
                )
              )
            }
          }
        }
      }
    }
    return .success((directArguments, options))
  }

  private func parse(
    possibleDirectArgument: StrictString,
    parsedDirectArguments: inout DirectArguments,
    expectedDirectArguments: inout ArraySlice<AnyArgumentTypeDefinition>
  ) -> Result<Bool, Command.Error> {

    guard let definition = expectedDirectArguments.popFirst() else {
      return .success(false)  // Not a direct argument.
    }

    guard let parsed = definition.parse(argument: possibleDirectArgument) else {
      let commandStack = Command.stack  // Prevent delayed evaluation.
      return .failure(
        Command.Error(
          description: UserFacing<StrictString, InterfaceLocalization>({ localization in
            let commandName = self.localizedName()
            var result: StrictString
            switch localization {
            case .englishUnitedKingdom:
              result = "An argument for ‘\(commandName)’ is invalid: \(possibleDirectArgument)"
            case .englishUnitedStates, .englishCanada:
              result = "An argument for “\(commandName)” is invalid: \(possibleDirectArgument)"
            case .deutschDeutschland:
              result = "Ein Argument zu „\(commandName)“ ist ungültig: \(possibleDirectArgument)"
            }
            return result + "\n"
              + Command.helpInstructions(for: commandStack).resolved(for: localization)
          })
        )
      )
    }

    parsedDirectArguments.add(value: parsed)
    return .success(true)
  }

  private func removeOptionMarker(from possibleOption: StrictString) -> StrictString? {
    for marker in Option<Any>.optionMarkers where possibleOption.hasPrefix(marker) {
      return possibleOption.dropping(through: marker)
    }
    return nil
  }

  private func parse(
    possibleOption: StrictString,
    remainingArguments: inout ArraySlice<StrictString>,
    parsedOptions: inout Options
  ) -> Result<Bool, Command.Error> {

    guard let name = removeOptionMarker(from: possibleOption) else {
      // Not an option.
      return .success(false)
    }

    for option in options where option.matches(name: name) {

      if option.type().identifier() == ArgumentType.booleanIdentifier {
        // Boolean flags take no arguments.
        parsedOptions.add(value: true, for: option)
        return .success(true)
      }

      guard let argument = remainingArguments.popFirst() else {
        let commandStack = Command.stack  // Prevent delayed evaluation.
        return .failure(
          Command.Error(
            description: UserFacing<StrictString, InterfaceLocalization>({ localization in
              let optionName = ("•" + option.localizedName())
              var result: StrictString
              switch localization {
              case .englishUnitedKingdom:
                result = "The argument is missing for ‘\(optionName)’."
              case .englishUnitedStates, .englishCanada:
                result = "The argument is missing for “\(optionName)”."
              case .deutschDeutschland:
                result = "Das Argument zu „\(optionName)“ fehlt."
              }
              return result + "\n"
                + Command.helpInstructions(for: commandStack).resolved(for: localization)
            })
          )
        )
      }

      guard let parsed = option.type().parse(argument: argument) else {
        let commandStack = Command.stack  // Prevent delayed evaluation.
        return .failure(
          Command.Error(
            description: UserFacing<StrictString, InterfaceLocalization>({ localization in
              let optionName = ("•" + option.localizedName())
              var result: StrictString
              switch localization {
              case .englishUnitedKingdom:
                result = "The argument for ‘\(optionName)’ is invalid: \(argument)"
              case .englishUnitedStates, .englishCanada:
                result = "The argument for “\(optionName)” is invalid: \(argument)"
              case .deutschDeutschland:
                result = "Das Argument zu „\(optionName)“ ist ungültig: \(argument)"
              }
              return result + "\n"
                + Command.helpInstructions(for: commandStack).resolved(for: localization)
            })
          )
        )
      }

      parsedOptions.add(value: parsed, for: option)
      return .success(true)
    }

    let commandStack = Command.stack  // Prevent delayed evaluation.
    return .failure(
      Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
          let optionName = ("•" + name)
          var result: StrictString
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            result = "Invalid option: \(optionName)"
          case .deutschDeutschland:
            result = "Ungültige Option: \(optionName)"
          }
          return result + "\n"
            + Command.helpInstructions(for: commandStack).resolved(for: localization)
        })
      )
    )
  }

  #if !PLATFORM_LACKS_FOUNDATION_PROCESS
    private func parseVersion(
      from arguments: [StrictString]
    ) -> Result<(version: Build, otherArguments: [StrictString])?, Command.Error> {

      var remaining = arguments[arguments.bounds]

      while let argument = remaining.popFirst() {

        if let name = removeOptionMarker(from: argument),
          Options.useVersion.matches(name: name)
        {

          var options = Options()
          let optionAttempt = parse(
            possibleOption: argument,
            remainingArguments: &remaining,
            parsedOptions: &options
          )
          switch optionAttempt {
          case .failure(let error):
            return .failure(error)
          case .success(let isOption):
            if isOption,
              let version = options.value(for: Options.useVersion)
            {

              let index = arguments.endIndex − remaining.count − 2
              let otherArguments = Array(arguments[0..<index]) + Array(remaining)
              return .success((version: version, otherArguments: otherArguments))
            }
          }
        }
      }

      return .success(nil)
    }
  #endif

  private static func helpInstructions(
    for commandStack: [Command]
  ) -> UserFacing<StrictString, InterfaceLocalization> {
    var command = commandStack.map({ $0.localizedName() }).joined(separator: " ")
    command.append(contentsOf: " " + Command.help.localizedName())
    command = command.prepending(contentsOf: "$ ".scalars)

    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "See also: \(command)"
      case .deutschDeutschland:
        return "Siehe auch: \(command)"
      }
    })
  }

  // MARK: - Name Normalization

  internal static func normalizeToUnicode<L: Localization>(
    _ string: StrictString,
    in localization: L
  ) -> StrictString {
    let hyphen: StrictString
    if let interfaceLocalization = SystemLocalization(reasonableMatchFor: localization.code) {
      switch interfaceLocalization {
      case .普通话中国, .國語中國, .日本語日本国, .한국어한국, .ไทยไทย:
        // Unspaced orthography, no need for joiner anyway.
        hyphen = "‐"
      case .العربية_السعودية, .हिन्दी_भारत:  // No native joiner. Use generic hyphen.
        hyphen = "‐"
      case .españolEspaña, .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .portuguêsPortugal, .русскийРоссия, .deutschDeutschland, .tiếngViệtViệtNam, .françaisFrance,
        .türkçeTürkiye, .italianoItalia, .polskiPolska, .українськаУкраїна, .nederlandsNederland,
        .malaysiaMalaysia, .românăRomânia, .ελληνικάΕλλάδα, .češtinaČesko, .magyarMagyarország,
        .svenskaSverige, .indonesiaIndonesia, .danskDanmark, .suomiSuomi, .slovenčinaSlovensko,
        .norskNorge, .hrvatskiHrvatska, .catalàEspanya:
        hyphen = "‐"
      case .עברית־ישראל:
        hyphen = "־"
      }
    } else {
      hyphen = "‐"
    }
    return string.replacingMatches(for: "\u{2D}", with: hyphen)
  }

  internal static func normalizeToAscii(_ string: StrictString) -> StrictString {
    let asciiHyphen: StrictString = "\u{2D}"
    var result = string
    result.replaceMatches(for: "‐", with: asciiHyphen)
    result.replaceMatches(for: "־", with: asciiHyphen)
    return result
  }

  internal static func list<L: InputLocalization>(names: UserFacing<StrictString, L>) -> Set<
    StrictString
  > {
    var result: Set<StrictString> = []
    for localization in L.allCases {
      let name = names.resolved(for: localization)
      result.insert(Command.normalizeToUnicode(name, in: localization))
      result.insert(Command.normalizeToAscii(name))
    }
    return result
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    return String(localizedName())
  }

  // MARK: - Encodable

  private enum CodingKeys: String, CodingKey {
    case identifier
    case name
    case description
    case discussion
    case subcommands
    case arguments
    case options
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(localizedName(), forKey: .name)
    try container.encode(localizedDescription(), forKey: .description)
    try container.encode(localizedDiscussion(), forKey: .discussion)
    try container.encode(subcommands.filter({ ¬$0.isHidden }), forKey: .subcommands)
    try container.encode(directArguments.map({ $0.interface() }), forKey: .arguments)
    try container.encode(options.filter({ ¬$0.isHidden }).map({ $0.interface() }), forKey: .options)
  }
}
