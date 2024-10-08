/*
 ReadMe.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2017–2024 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization
import SDGVersioning
import SDGSwift

import SDGCommandLine

import XCTest

func main() {
  // @example(main.swift🇨🇦EN)
  Parrot.main()
  // @endExample
}

// @example(parrotLibrary🇨🇦EN)
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
// @endExample

class ReadMeExampleTests: CommandLineTestCase {

  // @example(parrotTests🇨🇦EN)
  func testParrot() {
    switch parrot.execute(with: ["speak", "•phrase", "Hello, world!"]) {
    case .success(let output):
      XCTAssertEqual(output, "Hello, world!")
    case .failure:
      XCTFail("The parrot is not co‐operating.")
    }
  }
  // @endExample
}
