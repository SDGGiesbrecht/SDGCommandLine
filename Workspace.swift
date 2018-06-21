/*
 Workspace.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration.applySDGDefaults()

configuration.documentation.currentVersion = Version(0, 3, 1)

configuration.documentation.projectWebsite = URL(string: "https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine")!
configuration.documentation.documentationURL = URL(string: "https://sdggiesbrecht.github.io/SDGCommandLine")!
configuration.documentation.api.yearFirstPublished = 2017
configuration.documentation.repositoryURL = URL(string: "https://github.com/SDGGiesbrecht/SDGCommandLine")!

configuration.supportedOperatingSystems.remove(.iOS)
configuration.supportedOperatingSystems.remove(.watchOS)
configuration.supportedOperatingSystems.remove(.tvOS)

configuration.documentation.localizations = ["🇨🇦EN"]

configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "SDGCommandLine provides tools for implementing a command line interface."

configuration.documentation.readMe.quotation = Quotation(original: "יְהַלְלוּ אֶת־שֵׁם יהוה כִּי הוּא צִוָּה וְנִבְרָאוּ׃")
configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = "May they praise the name of the Lord, for He commanded and they came into being!"
configuration.documentation.readMe.quotation?.link["🇨🇦EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV")!
configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = "a psalmist"

configuration.documentation.readMe.featureList["🇨🇦EN"] = [
    "\u{2D} Automatic parsing of options and subcommands",
    "\u{2D} Automatic `help` subcommand",
    "\u{2D} Testable output",
    "\u{2D} Colour formatting tools",
    "  \u{2D} Automatic `•no‐colour` option",
    "\u{2D} Interface localization",
    "  \u{2D} Automatic `set‐language` subcommand to set language preferences.",
    "  \u{2D} Automatic `•language` option to run in a specific language only once.",
    "\u{2D} Versioning tools",
    "  \u{2D} Automatic `version` subcommand",
    "  \u{2D} Automatic `•use‐version` option to attempt to download and temporarily use a specific version instead of the one which is installed (only for public Swift packages)."
].joinedAsLines()

configuration.documentation.readMe.exampleUsage["🇨🇦EN"] = [
    "This example creates a tool with the following interface:",
    "",
    "```shell",
    "$ parrot speak",
    "Squawk!",
    "",
    "$ parrot speak •phrase \u{22}Hello, world!\u{22}",
    "Hello, world!",
    "```",
    "",
    "`main.swift` must consist of the following lines:",
    "",
    "#example(main.swift 🇨🇦EN)",
    "",
    "The rest can be anywhere in the project (but putting it in a separate, testable library module is recommended):",
    "",
    "#example(ParrotLibrary 🇨🇦EN)",
    "",
    "Tests are easy to set up:",
    "",
    "#example(ParrotTests 🇨🇦EN)"
    ].joinedAsLines()

configuration.documentation.api.encryptedTravisCIDeploymentKey = "rHheTc8sUxKAdE0Wfx6FveDJC+dwlHt3ZIJc5csxoPQge4LtqufFte3OBYVNNL+8RbyxfP25xD5nNKNVl8BAwa6uvMgmpRCSRxHRjk/nI+gioeiFocQWBXNb9EcuDjnshMc64XzeGj0gIWCD2H81daDyY9ysrLY7Y/ZREdczsMMDRAwyBuV15iC/d7tiJYy/07Pwg/3Rja8wZJFw/7fYu6x6Wk7aeFnxrb6KUyPiUexgn2PupX+E/0U1C0VAJsUS4r6p7N4spZeloeqlH8bdlrqotpvSS/h8Ui4NWL9Ke5yWyfY4E7l3cDl+I7YlLa7AGiOuOGEFVVMgaRQo/MrtrBYraGcUC+lBt6jmP6nDQb4n1Q0SvFvpFlzVtqOs7Y44oHMfGgINBNjMuGf3SKFG57jFpRJoLGOEb4kS+HkW35pefQlGTlIKKPZvjliBN71yagsRyJQI+dKX5jfSeUtstaNyVBFch8zz70bnC3YZEgAYnGDC283O3r1TmIyyMlpAbejv8dLd/JnpLzAzkVay73lBbtt1Fqqusn2C6k/U2X+/avwj08rW/Ui+2LFWt4D93pqpi00mX9+oxgaBikuncq6G6AxV5H6AZwMiCDTQwQeSASgJCYN5WAqq4F9hbHvHlTJkoulv+nSihsmmdnfHoxTuUwfwrGJki6TJrg1hQqE="

configuration.applySDGOverrides()
configuration.validateSDGStandards()
