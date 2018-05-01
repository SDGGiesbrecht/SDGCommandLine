/*
 ReadMe.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCommandLine

func main() {
    // [_Define Example: main.swift 🇨🇦EN_]
    ProcessInfo.applicationIdentifier = "tld.Developper.Parrot"
    ProcessInfo.version = Version(1, 0, 0)
    ProcessInfo.packageURL = URL(string: "https://website.tld/Parrot")

    parrot.executeAsMain()
    // [_End_]
}

// [_Define Example: ParrotLibrary 🇨🇦EN_]
import SDGCommandLine

public let parrot = Command(name: UserFacing<StrictString, MyLocalizations>({ _ in "parrot" }),
                            description: UserFacing<StrictString, MyLocalizations>({ _ in "behaves like a parrot." }),
                            subcommands: [speak])

let speak = Command(name: UserFacing<StrictString, MyLocalizations>({ _ in "speak" }),
                    description: UserFacing<StrictString, MyLocalizations>({ _ in "speaks." }),
                    directArguments: [],
                    options: [phrase],
                    execution: { (_, options: Options, output: Command.Output) throws -> Void in

                        if let specific = options.value(for: phrase) {
                            output.print(specific)
                        } else {
                            output.print("Squawk!")
                        }
})

let phrase = Option<StrictString>(name: UserFacing<StrictString, MyLocalizations>({ _ in "phrase" }),
                                  description: UserFacing<StrictString, MyLocalizations>({ _ in "A custom phrase to speak." }),
                                  type: ArgumentType.string)

enum MyLocalizations : String, InputLocalization {
    case english = "en"
    internal static let cases: [MyLocalizations] = [.english]
    internal static let fallbackLocalization: MyLocalizations = .english
}
// [_End_]

class ReadMeExampleTests : TestCase {

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
}
