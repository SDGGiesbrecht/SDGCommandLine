/*
 ReadMe.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone
import SDGCommandLine

func main() {
    // [_Define Example: main.swift 🇨🇦EN_]
    SDGCommandLine.initialize(applicationIdentifier: "tld.Developper.Parrot", version: Version(1, 0, 0), packageURL: URL(string: "https://website.tld/Parrot"))
    parrot.executeAsMain()
    // [_End_]
}

// [_Define Example: ParrotLibrary 🇨🇦EN_]
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
// [_End_]

// [_Define Example: ParrotTests 🇨🇦EN_]
func testParrot() {
    do {
        let output = try parrot.execute(with: ["speak", "•phrase", "Hello, world!"])
        XCTAssertEqual(output, "Hello, world!")
    } catch {
        XCTFail("The parrot is not co‐operating.")
    }
}
// [_End_]
