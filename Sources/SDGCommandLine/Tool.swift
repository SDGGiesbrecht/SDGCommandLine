/*
 Tool.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2020–2023 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGPersistence
import SDGText
import SDGVersioning

/// A command line tool.
///
/// `@main` can be applied to conforming types.
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
  public static func main() {  // @exempt(from: tests)
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      ProcessInfo.applicationIdentifier = String(applicationIdentifier)
    #endif
    if let version = version {  // @exempt(from: tests)
      #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
        ProcessInfo.version = version
      #endif
    }
    if let packageURL = packageURL {  // @exempt(from: tests)
      #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
        ProcessInfo.packageURL = packageURL
      #endif
    }
    rootCommand.executeAsMain()
  }
}
