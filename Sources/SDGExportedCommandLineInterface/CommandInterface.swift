/*
 CommandInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2019–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGPersistence
import SDGExternalProcess

/// A command.
public struct CommandInterface: Decodable {

  // MARK: - Static Methods

  #if !PLATFORM_LACKS_FOUNDATION_PROCESS
    /// Attempt to load the interface of the tool at the specified URL.
    ///
    /// The tool must use `SDGCommandLine` and it must have been built in the debug configuration.
    ///
    /// - Parameters:
    ///     - tool: The URL of tool executable.
    ///     - language: A language for the exported descriptions. This parameter accepts the same codes as the `•language` command line option.
    public static func loadInterface(
      of tool: URL,
      in language: String
    ) -> Result<CommandInterface, ExternalProcess.Error> {
      let process = ExternalProcess(at: tool)
      switch process.run([
        "export‐interface",
        "•language",
        language,
      ]) {
      case .failure(let error):
        return .failure(error)
      case .success(let exported):
        do {
          return .success(try CommandInterface(export: exported))
        } catch {
          return .failure(.foundationError(error))
        }
      }
    }
  #endif

  // MARK: - Initialization

  internal init(export: String) throws {
    self = try JSONDecoder().decode(CommandInterface.self, from: export.file)
  }

  private init<Decoded>(from decoded: Decoded) where Decoded: DecodedCommandInterface {
    self.identifier = decoded.identifier
    self.name = decoded.name
    self.description = decoded.description
    self.discussion = decoded.discussion
    self.subcommands = decoded.subcommands
    self.arguments = decoded.arguments
    self.infiniteFinalArgument = decoded.infiniteFinalArgument
    self.options = decoded.options
  }

  // MARK: - Properties

  /// An unique identifier that can be compared across localizations to find corresponding commands.
  public var identifier: StrictString

  /// The name.
  public var name: StrictString

  /// The description.
  public var description: StrictString

  /// Additional in‐depth information.
  public var discussion: StrictString?

  /// Subcommands.
  public var subcommands: [CommandInterface]

  /// Arguments.
  public var arguments: [ArgumentInterface]

  /// Whether or not the command accepts an infinite number of arguments, with the final argument type extended to apply to those at higher indices.
  public var infiniteFinalArgument: Bool

  /// Options.
  public var options: [OptionInterface]

  // MARK: - Decodable

  public init(from decoder: Decoder) throws {
    if let decoded = try? Version2(from: decoder) {
      self.init(from: decoded)
    } else {
      self.init(from: try Version1(from: decoder))
    }
  }
}
