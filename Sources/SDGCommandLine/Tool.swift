/*
 Tool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGPersistence
import SDGText
import SDGVersioning

/// A command line tool.
public protocol Tool {

  /// The application identifier.
  static var applicationIdentifier: StrictString { get }

  /// The version.
  static var version: Version? { get }

  /// A package URL the tool can be fetched from for the `•use‐version` subcommand.
  static var packageURL: URL? { get }

  /// The root command.
  static var rootCommand: Command { get }
}

extension Tool {

  /// Initializes and runs the tool.
  ///
  /// This method never returns. It is only marked `Void` for compatibility with `@main`.
  public static func main() -> Void {
    ProcessInfo.applicationIdentifier = String(applicationIdentifier)
    if let version = version {
      ProcessInfo.version = version
    }
    if let packageURL = packageURL {
      ProcessInfo.packageURL = packageURL
    }
    rootCommand.executeAsMain()
  }
}
