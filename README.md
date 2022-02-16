<!--
 README.md

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2022 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

macOS • Windows • Web • Ubuntu • tvOS • iOS • Android • Amazon Linux • watchOS

[Documentation](https://sdggiesbrecht.github.io/SDGCommandLine/%F0%9F%87%A8%F0%9F%87%A6EN)

# SDGCommandLine

SDGCommandLine provides tools for implementing a command line interface.

> [יְהַלְלוּ אֶת־שֵׁם יהוה כִּי הוּא צִוָּה וְנִבְרָאוּ׃](https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV)
>
> [May they praise the name of the Lord, for He commanded and they came into being!](https://www.biblegateway.com/passage/?search=Psalm+148&version=WLC;NIV)
>
> ―a psalmist

### Features

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

### Example Usage

This example creates a tool with the following interface:

```shell
$ parrot speak
Squawk!

$ parrot speak •phrase "Hello, world!"
Hello, world!
```

`main.swift` must consist of the following:

```swift
Parrot.main()
```

The rest can be anywhere in the project (but putting it in a separate, testable library module is recommended):

```swift
import SDGCommandLine

struct Parrot: Tool {
  static let applicationIdentifier: StrictString = "tld.Developper.Parrot"
  static let version: Version? = Version(1, 0, 0)
  static let packageURL: URL? = URL(string: "https://website.tld/Parrot")
  static let rootCommand: Command = parrot
}

let parrot = Command(
  name: UserFacing<StrictString, MyLocalizations>({ _ in "parrot" }),
  description: UserFacing<StrictString, MyLocalizations>({ _ in "behaves like a parrot." }),
  subcommands: [speak]
)

let speak = Command(
  name: UserFacing<StrictString, MyLocalizations>({ _ in "speak" }),
  description: UserFacing<StrictString, MyLocalizations>({ _ in "speaks." }),
  directArguments: [],
  options: [phrase],
  execution: { (_, options: Options, output: Command.Output) throws -> Void in

    if let specific = options.value(for: phrase) {
      output.print(specific)
    } else {
      output.print("Squawk!")
    }
  }
)

let phrase = Option<StrictString>(
  name: UserFacing<StrictString, MyLocalizations>({ _ in "phrase" }),
  description: UserFacing<StrictString, MyLocalizations>({ _ in "A custom phrase to speak." }),
  type: ArgumentType.string
)

enum MyLocalizations: String, InputLocalization {
  case english = "en"
  static let cases: [MyLocalizations] = [.english]
  static let fallbackLocalization: MyLocalizations = .english
}
```

Tests are easy to set up:

```swift
func testParrot() {
  switch parrot.execute(with: ["speak", "•phrase", "Hello, world!"]) {
  case .success(let output):
    XCTAssertEqual(output, "Hello, world!")
  case .failure:
    XCTFail("The parrot is not co‐operating.")
  }
}
```

Some platforms lack certain features. The compilation conditions which appear throughout the documentation are defined as follows:

```swift
.define("PLATFORM_LACKS_FOUNDATION_PROCESS", .when(platforms: [.wasi, .tvOS, .iOS, .watchOS])),
.define("PLATFORM_LACKS_FOUNDATION_PROCESS_INFO", .when(platforms: [.wasi])),
```

## Importing

SDGCommandLine provides libraries for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add SDGCommandLine as a dependency in `Package.swift` and specify which of the libraries to use:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "SDGCommandLine",
      url: "https://github.com/SDGGiesbrecht/SDGCommandLine",
      from: Version(1, 7, 8)
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "SDGCommandLine", package: "SDGCommandLine"),
        .product(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine"),
        .product(name: "SDGExportedCommandLineInterface", package: "SDGCommandLine"),
      ]
    )
  ]
)
```

The modules can then be imported in source files:

```swift
import SDGCommandLine
import SDGCommandLineTestUtilities
import SDGExportedCommandLineInterface
```

## About

The SDGCommandLine project is maintained by Jeremy David Giesbrecht.

If SDGCommandLine saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If SDGCommandLine saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/SDGCommandLine) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> ―‎ישוע/Yeshuʼa
