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

import SDGCommandLineLocalizations

import SDGSwift
// [_Warning: Temporary_]
import SDGSwiftPackageManager

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
        super.init(name: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Swift"
            }
        }), webpage: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
            switch localization { // [_Exempt from Test Coverage_]
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada /* No localized site: */: // [_Exempt from Test Coverage_]
                return "swift.org"
            }
        }), command: "swift", version: version, versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage: Workflow

    private func resolve(output: Command.Output) throws {
        _ = try SDGSwift.PackageRepository(at: URL(fileURLWithPath: FileManager.default.currentDirectoryPath)).resolve(reportProgress: { output.print($0) })
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
        return Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada: // [_Exempt from Test Coverage_]
                return StrictString("Error loading package description:\n\(json)")
            }
        }))
    }

    /// :nodoc: (Shared to Workspace.)
    public func _packageStructure(output: Command.Output) throws -> (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)]) {

        let workingDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let currentRepository = SDGSwift.PackageRepository(at: workingDirectory)
        let manifest = try currentRepository.manifest()
        let package = try currentRepository.package()

        var libraryProductTargets: [String] = []
        var executableProducts: [String] = []
        for product in package.products {
            switch product.type {
            case .library(_):
                for target in product.targets {
                    libraryProductTargets.append(target.name)
                }
            case .executable:
                executableProducts.append(product.name)
            case .test:
                continue
            }
        }
        var targets: [(name: String, location: URL)] = []
        for target in manifest.package.targets {
            let path: String
            if let specified = target.path {
                path = specified
            } else {
                if target.isTest {
                    path = "Tests/" + target.name
                } else {
                    path = "Sources/" + target.name
                }
            }
            targets.append((name: target.name, location: currentRepository.location.appendingPathComponent(path)))
        }

        return (name: package.name, libraryProductTargets: libraryProductTargets, executableProducts: executableProducts, targets: targets)
    }
}
