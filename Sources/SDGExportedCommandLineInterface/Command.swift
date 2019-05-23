/*
 Command.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGPersistence
import SDGExternalProcess

/// A command.
public struct CommandInterface : Decodable {

    public static func loadInterface(of tool: URL) -> Result<CommandInterface, ExternalProcess.Error> {
        let process = ExternalProcess(at: tool)
        switch process.run(["export‐interface"]) {
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

    private init(export: String) throws {
        self = try JSONDecoder().decode(CommandInterface.self, from: export.file)
    }
}
