/*
 Workspace.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(1, 0, 1)

configuration.documentation.projectWebsite = URL(string: "https://sdggiesbrecht.github.io/SDGCommandLine")!
configuration.documentation.documentationURL = URL(string: "https://sdggiesbrecht.github.io/SDGCommandLine")!
configuration.documentation.api.yearFirstPublished = 2017
configuration.documentation.repositoryURL = URL(string: "https://github.com/SDGGiesbrecht/SDGCommandLine")!

configuration.supportedPlatforms.remove(.iOS)
configuration.supportedPlatforms.remove(.watchOS)
configuration.supportedPlatforms.remove(.tvOS)

configuration.documentation.localizations = ["🇨🇦EN"]

configuration.documentation.api.encryptedTravisCIDeploymentKey = "rHheTc8sUxKAdE0Wfx6FveDJC+dwlHt3ZIJc5csxoPQge4LtqufFte3OBYVNNL+8RbyxfP25xD5nNKNVl8BAwa6uvMgmpRCSRxHRjk/nI+gioeiFocQWBXNb9EcuDjnshMc64XzeGj0gIWCD2H81daDyY9ysrLY7Y/ZREdczsMMDRAwyBuV15iC/d7tiJYy/07Pwg/3Rja8wZJFw/7fYu6x6Wk7aeFnxrb6KUyPiUexgn2PupX+E/0U1C0VAJsUS4r6p7N4spZeloeqlH8bdlrqotpvSS/h8Ui4NWL9Ke5yWyfY4E7l3cDl+I7YlLa7AGiOuOGEFVVMgaRQo/MrtrBYraGcUC+lBt6jmP6nDQb4n1Q0SvFvpFlzVtqOs7Y44oHMfGgINBNjMuGf3SKFG57jFpRJoLGOEb4kS+HkW35pefQlGTlIKKPZvjliBN71yagsRyJQI+dKX5jfSeUtstaNyVBFch8zz70bnC3YZEgAYnGDC283O3r1TmIyyMlpAbejv8dLd/JnpLzAzkVay73lBbtt1Fqqusn2C6k/U2X+/avwj08rW/Ui+2LFWt4D93pqpi00mX9+oxgaBikuncq6G6AxV5H6AZwMiCDTQwQeSASgJCYN5WAqq4F9hbHvHlTJkoulv+nSihsmmdnfHoxTuUwfwrGJki6TJrg1hQqE="

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
