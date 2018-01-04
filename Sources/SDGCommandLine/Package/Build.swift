/*
 Build.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal enum Build : Equatable {

    // MARK: - Static Properties

    internal static let current: Build? = {
        guard let versionNumber = Version.currentToolVersion else {
            return nil
        }
        return .version(versionNumber)
    }()

    // MARK: - Cases

    case version(Version)
    case development

    // MARK: - Equatable

    internal static func == (lhs: Build, rhs: Build) -> Bool {
        switch lhs {
        case .development:
            switch rhs {
            case .development:
                return true
            case .version:
                return false
            }
        case .version(let lhsVersion):
            switch rhs {
            case .development:
                return false
            case .version(let rhsVersion):
                return lhsVersion == rhsVersion
            }
        }
    }
}
