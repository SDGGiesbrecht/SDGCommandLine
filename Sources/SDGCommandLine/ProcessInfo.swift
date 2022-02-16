/*
 ProcessInfo.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
  import Foundation

  import SDGVersioning

  import SDGSwift

  extension ProcessInfo {

    /// The semantic version of the tool’s package; set it before calling `Command.executeAsMain()`.
    ///
    /// This will be displayed by the `version` subcommand.
    ///
    /// It is recommended to set this to `nil` in between stable releases.
    public static var version: Version?

    /// The URL of the tool’s Swift package; set it before calling `Command.executeAsMain()`.
    ///
    /// This is where the `•use‐version` option will look for other versions. The specified repository must be a valid Swift package that builds successfully with nothing more than `swift build`. If the repository is not publicly available or not a Swift package, this should be set to `nil`, in which case the `•use‐version` option will be unavailable.
    public static var packageURL: URL?
  }
#endif
