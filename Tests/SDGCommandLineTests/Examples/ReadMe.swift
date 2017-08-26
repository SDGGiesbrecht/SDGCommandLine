/*
 ReadMe.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

// [_Define Example: Read‐Me_]

/*
 This example creates a tool with the following interface:

 $ parrot greet
 Hello, world!
 */

/*
 // main.swift must consist of the following lines:

 import SDGCommandLine

 SDGCommandLine.initialize(applicationIdentifier: "tld.Developper.Parrot")
 parrot.executeAsMain()

 */

// The rest can be anywhere in the project:
// (putting it in a separate, testable library module is recommended)

import SDGCornerstone // See https://sdggiesbrecht.github.io/SDGCornerstone/macOS/
import SDGCommandLine

public let parrot = Command(name: UserFacingText<MyLocalizations, Void>({ _, _ in "parrot" }),
                            description: UserFacingText<MyLocalizations, Void>({ _, _ in "behaves like a parrot." }),
                            subcommands: [greet])

let greet = Command(name: UserFacingText<MyLocalizations, Void>({ _, _ in "greet" }),
                    description: UserFacingText<MyLocalizations, Void>({ _, _ in "says, “Hello, world!”." }),
                    options: [],
                    execution: { (_, output: inout Command.Output) throws -> Void in

                        print("Hello, world!", to: &output)
})

enum MyLocalizations : String, InputLocalization {
    case english = "en"
    internal static let cases: [MyLocalizations] = [.english]
    internal static let fallbackLocalization: MyLocalizations = .english
}

// It is easy to set up tests:

func testParrot() {
    do {
        let output = try parrot.execute(with: ["greet"])
        XCTAssertEqual(output, "Hello, World!")
    } catch {
        XCTFail("The command failed.")
    }
}

// [_End_]
