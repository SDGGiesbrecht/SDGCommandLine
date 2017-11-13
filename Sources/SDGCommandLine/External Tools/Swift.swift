/*
 Swift.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

internal typealias SwiftTool = _Swift
/// :nodoc: (Shared to Workspace.)
public class _Swift : _ExternalTool {

    // MARK: - Static Properties

    private static let version = Version(4, 0, 0)

    /// :nodoc: (Shared to Workspace.)
    public static let _default: _Swift = SwiftTool(version: SwiftTool.version)
    internal static let `default` = _default

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Swift"
            case .ελληνικάΕλλάδα:
                return "Σουιφτ"
            case .עברית־ישראל:
                return "סוויפט"
            }
        }), webpage: UserFacingText({ (localization: InterfaceLocalization, _: Void) -> StrictString in // [_Exempt from Code Coverage_]
            switch localization { // [_Exempt from Code Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל: // [_Exempt from Code Coverage_]
                return "swift.org"
            }
        }), command: "swift", version: version, versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage: Workflow

    internal func initializeExecutablePackage(output: inout Command.Output) throws {
        _ = try execute(with: [
            "package", "init",
            "\u{2D}\u{2D}type", "executable"
            ], output: &output)
    }

    internal func buildForRelease(output: inout Command.Output) throws {
        _ = try execute(with: [
            "build",
            "\u{2D}\u{2D}configuration", "release",
            "\u{2D}\u{2D}static\u{2D}swift\u{2D}stdlib"
            ], output: &output)
    }

    // MARK: - Usage: Information

    /// :nodoc: (Shared to Workspace.)
    public func _targets(output: inout Command.Output) throws -> [(name: String, location: URL)] {

        let json = try executeInCompatibilityMode(with: [
            "package",
            "dump\u{2D}package"
            ], output: &output, silently: true)

        let parseError = Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada: // [_Exempt from Code Coverage_]
                return StrictString("Error loading package description:\n\(json)")
            case .deutschDeutschland: // [_Exempt from Code Coverage_]
                return StrictString("Fehlschlag beim Laden der Paketbeschreibung:\n\(json)")
            case .françaisFrance: // [_Exempt from Code Coverage_]
                return StrictString("Échec du chargement de la description du paquet:\n\(json)")
            case .ελληνικάΕλλάδα: // [_Exempt from Code Coverage_]
                return StrictString("Αποτυχία της φόρτωσης της περιγραφής του δέματος:\n\(json)")
            case .עברית־ישראל: // [_Exempt from Code Coverage_]
                return StrictString("שגיאה בטעינת תיאור החבילה:\n\(json)")
            }
        }))

        guard let properties = (try JSONSerialization.jsonObject(with: json.file, options: []) as? PropertyListValue)?.as([String: Any].self),
            let targets = (properties["targets"] as? PropertyListValue)?.as([Any].self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
                throw parseError
        }

        let repositoryRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

        return try targets.map() { (targetValue) -> (name: String, location: URL) in
            guard let targetInformation = (targetValue as? PropertyListValue)?.as([String: Any].self),
                let name = (targetInformation["name"] as? PropertyListValue)?.as(String.self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError
            }

            var path: String
            if let specific = (targetInformation["path"] as? PropertyListValue)?.as(String.self) { // [_Exempt from Code Coverage_]
                path = specific
            } else {
                if (targetInformation["isTest"] as? PropertyListValue)?.as(Bool.self) == true {
                    path = "Tests/" + name
                } else {
                    path = "Sources/" + name
                }
            }

            return (name, repositoryRoot.appendingPathComponent(path))
        }
    }
}
