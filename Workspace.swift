/*
 Workspace.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2018–2021 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(1, 7, 0)

configuration.documentation.projectWebsite = URL(
  string: "https://sdggiesbrecht.github.io/SDGCommandLine"
)!
configuration.documentation.documentationURL = URL(
  string: "https://sdggiesbrecht.github.io/SDGCommandLine"
)!
configuration.documentation.api.yearFirstPublished = 2017
configuration.documentation.repositoryURL = URL(
  string: "https://github.com/SDGGiesbrecht/SDGCommandLine"
)!

configuration.documentation.localizations = ["🇨🇦EN"]

configuration._applySDGOverrides()
configuration._validateSDGStandards()

configuration.testing.exemptPaths.insert("Tests")

configuration.documentation.api.ignoredDependencies = [

  // llbuild
  "libllbuild",
  "llbuildBasic",
  "llbuildBuildSystem",
  "llbuildCore",
  "llbuildSwift",
  "llvmSupport",

  // SDGCornerstone
  "SDGCalendar",
  "SDGCollections",
  "SDGCornerstoneLocalizations",
  "SDGExternalProcess",
  "SDGLocalizationTestUtilities",
  "SDGLogic",
  "SDGMathematics",
  "SDGPersistence",
  "SDGPersistenceTestUtilities",
  "SDGTesting",
  "SDGText",
  "SDGXCTestUtilities",

  // SDGSwift
  "SDGSwift",
  "SDGSwiftLocalizations",
  "SDGSwiftPackageManager",

  // Swift
  "Dispatch",
  "Foundation",
  "XCTest",

  // SwiftPM
  "Basic",
  "Build",
  "clibc",
  "PackageGraph",
  "PackageLoading",
  "PackageModel",
  "POSIX",
  "SourceControl",
  "SPMLibc",
  "SPMLLBuild",
  "SPMUtility",
  "Workspace",
  "Xcodeproj",
]
