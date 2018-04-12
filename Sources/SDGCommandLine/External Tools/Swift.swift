/*
 Swift.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCollections

internal typealias SwiftTool = _Swift
/// :nodoc: (Shared to Workspace.)
public class _Swift : _ExternalTool {

    // MARK: - Static Properties

    #if os(Linux)
        private static let version = Version(4, 1, 0)
    #else
        private static let version = Version(4, 1, 0)
    #endif

    /// :nodoc: (Shared to Workspace.)
    public static let _default: _Swift = SwiftTool(version: SwiftTool.version)
    internal static let `default` = _default

    // MARK: - Initialization

    internal init(version: Version) {
        super.init(name: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                return "Swift"
            case .ελληνικάΕλλάδα:
                return "Σουιφτ"
            case .עברית־ישראל:
                return "סוויפט"
            }
        }), webpage: UserFacingText({ (localization: InterfaceLocalization) -> StrictString in // [_Exempt from Test Coverage_]
            switch localization { // [_Exempt from Test Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, /* No localized site: */ .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל: // [_Exempt from Test Coverage_]
                return "swift.org"
            }
        }), command: "swift", version: version, versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage: Workflow

    internal func initializePackage(executable: Bool, output: Command.Output) throws {
        var arguments: [StrictString] = [
            "package", "init"
        ]
        if executable {
            arguments += [
                "\u{2D}\u{2D}type", "executable"
            ]
        }
        _ = try execute(with: arguments, output: output)
    }

    private func resolve(output: Command.Output) throws {
        _ = try execute(with: [
            "package", "resolve"
            ], output: output)
    }

    /// :nodoc: (Shared to Workspace.)
    public func _generateXcodeProject(output: Command.Output) throws {
        _ = try execute(with: [
            "package", "generate\u{2D}xcodeproj",
            "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"
        ], output: output)
    }

    /// :nodoc: (Shared to Workspace.)
    public func _test(output: Command.Output) throws { // [_Exempt from Test Coverage_] Incorrectly rerouted within xcodebuild.
        _ = try execute(with: [
            "test"
            ], output: output)
    }

    internal func buildForRelease(output: Command.Output) throws {
        _ = try execute(with: [
            "build",
            "\u{2D}\u{2D}configuration", "release",
            "\u{2D}\u{2D}static\u{2D}swift\u{2D}stdlib"
            ], output: output)
    }

    // MARK: - Usage: Information

    private func parseError(packageDescription json: String) -> Command.Error { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
        return Command.Error(description: UserFacingText<InterfaceLocalization>({ (localization) in // [_Exempt from Test Coverage_]
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada: // [_Exempt from Test Coverage_]
                return StrictString("Error loading package description:\n\(json)")
            case .deutschDeutschland: // [_Exempt from Test Coverage_]
                return StrictString("Fehlschlag beim Laden der Paketbeschreibung:\n\(json)")
            case .françaisFrance: // [_Exempt from Test Coverage_]
                return StrictString("Échec du chargement de la description du paquet:\n\(json)")
            case .ελληνικάΕλλάδα: // [_Exempt from Test Coverage_]
                return StrictString("Αποτυχία της φόρτωσης της περιγραφής του δέματος:\n\(json)")
            case .עברית־ישראל: // [_Exempt from Test Coverage_]
                return StrictString("שגיאה בטעינת תיאור החבילה:\n\(json)")
            }
        }))
    }

    /// :nodoc: (Shared to Workspace.)
    public func _packageStructure(output: Command.Output) throws -> (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)]) {

        try resolve(output: output) // If resolution interrupts the dump, the output is invalid JSON.

        let json = try executeInCompatibilityMode(with: [
            "package", "dump\u{2D}package"
            ], output: output, silently: true)

        guard let properties = try JSONSerialization.jsonObject(with: json.file, options: []) as? [String: Any] else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }

        guard let name = properties["name"] as? String else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }

        guard let products = properties["products"] as? [Any] else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }

        var libraryProductTargets: [String] = [] // Maintain order from Package.swift
        var executableProducts: [String] = [] // Maintain order from Package.swift
        var libraryProductTargetsSet: Set<String> = []
        for productEntry in products {
            guard let information = productEntry as? [String: Any],
                let type = information["product_type"] as? String else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError(packageDescription: json)
            }

            if type == "library" {
                guard let subtargets = information["targets"] as? [String] else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError(packageDescription: json)
                }

                for target in subtargets where target ∉ libraryProductTargetsSet {
                    libraryProductTargetsSet.insert(target)
                    libraryProductTargets.append(target)
                }
            } else if type == "executable" {
                guard let name = information["name"] as? String else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError(packageDescription: json)
                }
                executableProducts.append(name)
            }
        }

        guard let targets = properties["targets"] as? [Any] else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }
        let repositoryRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let targetList = try targets.map { (targetValue) -> (name: String, location: URL) in
            guard let targetInformation = targetValue as? [String: Any],
                let name = targetInformation["name"] as? String else { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError(packageDescription: json)
            }

            var path: String
            if let specific = targetInformation["path"] as? String { // [_Exempt from Test Coverage_]
                path = specific
            } else {
                if targetInformation["isTest"] as? Bool == true {
                    path = "Tests/" + name
                } else {
                    path = "Sources/" + name
                }
            }

            return (name, repositoryRoot.appendingPathComponent(path))
        }

        return (name: name, libraryProductTargets: libraryProductTargets, executableProducts: executableProducts, targets: targetList)
    }
}
