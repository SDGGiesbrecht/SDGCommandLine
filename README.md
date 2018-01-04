<!--
 README.md

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

APIs: [SDGCommandLine](https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine/SDGCommandLine)

# SDGCommandLine

SDGCommandLine provides tools for implementing a command line interface.

> [יְהַלְלוּ אֶת־שֵׁם יהוה כִּי הוּא צִוָּה וְנִבְרָאוּ׃<br>May they praise the name of the Lord, for He commanded and they came into being!](https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―a psalmist

## Features

- Automatic parsing of options and subcommands
- Automatic `help` subcommand
- Testable output
- Colour formatting tools
  - Automatic `•no‐colour` option
- Interface localization
  - Automatic `set‐language` subcommand to set language preferences.
  - Automatic `•language` option to run in a specific language only once.
- Versioning tools
  - Automatic `version` subcommand
  - Automatic `•use‐version` option to attempt to download and temporarily use a specific version instead of the one which is installed (only for public Swift packages).

(For a list of related projects, see [here](Documentation/🇨🇦EN%20Related%20Projects.md).) <!--Skip in Jazzy-->

## Importing

`SDGCommandLine` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add `SDGCommandLine` as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .upToNextMinor(from: Version(0, 1, 4))),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),
        ])
    ]
)
```

`SDGCommandLine` can then be imported in source files:

```swift
import SDGCommandLine
```

## Example Usage

This example creates a tool with the following interface:
```shell
 $ parrot speak
 Squawk!

 $ parrot speak •phrase "Hello, world!"
 Hello, world!
```

`main.swift` must consist of the following lines:
```swift
SDGCommandLine.initialize(applicationIdentifier: "tld.Developper.Parrot", version: Version(1, 0, 0), packageURL: URL(string: "https://website.tld/Parrot"))
parrot.executeAsMain()
```

The rest can be anywhere in the project
(but putting it in a separate, testable library module is recommended):
```swift
import SDGCornerstone // See https://sdggiesbrecht.github.io/SDGCornerstone/macOS/
import SDGCommandLine

public let parrot = Command(name: UserFacingText<MyLocalizations, Void>({ _, _ in "parrot" }),
                            description: UserFacingText<MyLocalizations, Void>({ _, _ in "behaves like a parrot." }),
                            subcommands: [speak])

let speak = Command(name: UserFacingText<MyLocalizations, Void>({ _, _ in "speak" }),
                    description: UserFacingText<MyLocalizations, Void>({ _, _ in "speaks." }),
                    directArguments: [],
                    options: [phrase],
                    execution: { (_, options: Options, output: inout Command.Output) throws -> Void in

                        if let specific = options.value(for: phrase) {
                            print(specific, to: &output)
                        } else {
                            print("Squawk!", to: &output)
                        }
})

let phrase = Option<StrictString>(name: UserFacingText<MyLocalizations, Void>({ _, _ in "phrase" }),
                                  description: UserFacingText<MyLocalizations, Void>({ _, _ in "A custom phrase to speak." }),
                                  type: ArgumentType.string)

enum MyLocalizations : String, InputLocalization {
    case english = "en"
    internal static let cases: [MyLocalizations] = [.english]
    internal static let fallbackLocalization: MyLocalizations = .english
}
```

Tests are easy to set up:
```swift
func testParrot() {
    do {
        let output = try parrot.execute(with: ["speak", "•phrase", "Hello, world!"])
        XCTAssertEqual(output, "Hello, world!")
    } catch {
        XCTFail("The parrot is not co‐operating.")
    }
}
```

## About

The SDGCommandLine project is maintained by Jeremy David Giesbrecht.

If SDGCommandLine saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If SDGCommandLine saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/SDGCommandLine) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa
