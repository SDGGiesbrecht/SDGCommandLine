/*
 Command.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGPersistenceTestUtilities

/// Tests a command.
///
/// This function will write the output to the test specification directory in the project repository and will compare against it on future calls. It is recommeded to check those specifications into source control to monitor changes in the description.
///
/// To update the specification instead of testing against it, change `overwriteSpecificationInsteadOfFailing` to `true` and re‐run the test suite. The specification will be rewritten to match the descriptions. *Do not forget to change it back afterward, or the test will cease to validate anything.*
///
/// - Parameters:
///     - command: A command to test.
///     - arguments: The arguments to supply to the command.
///     - workingDirectory: The directory to run the command in.
///     - localizations: The localization set to test.
///     - uniqueTestName: A unique name for the test. This is used in the path to the persistent test specifications.
///     - allowColour: Optional. Set to `true` to include colour in the specification. `false` by default.
///     - postprocess: Optional. A closure to postprocess the output before comparing against the specification. Use this to keep elements which vary out of the specification, such as by cleaning the user’s home directory out of any printed paths.
///     - output: The output to postprocess.
///     - overwriteSpecificationInsteadOfFailing: Set to `false` for normal behaviour. Set to `true` temporarily to update the specification.
///     - file: Optional. A different file to report as the failure location.
///     - line: Optional. A different line to report as the failure location.
public func testCommand<L>(
  _ command: Command,
  with arguments: [StrictString],
  in workingDirectory: URL? = nil,
  localizations: L.Type,
  uniqueTestName: StrictString,
  allowColour: Bool = false,
  postprocess: (_ output: inout String) -> Void = { _ in },
  overwriteSpecificationInsteadOfFailing: Bool,
  file: StaticString = #file,
  line: UInt = #line
) where L: InputLocalization {

  Command.Output.testMode = true

  let modifiedArguments = allowColour ? arguments : arguments + ["•no‐colour"]

  for localization in localizations.allCases {
    autoreleasepool {

      let filename: String
      if let icon = localization.icon {
        filename = String(icon)
      } else {
        filename = localization.code
      }

      let specification = testSpecificationDirectory(file).appendingPathComponent("Command")
        .appendingPathComponent(String(uniqueTestName)).appendingPathComponent(filename + ".txt")

      LocalizationSetting(orderOfPrecedence: [localization.code]).do {

        var report = ""
        print(
          "$ \(([command.localizedName()] + modifiedArguments).joined(separator: " "))",
          to: &report
        )

        var result: Result<StrictString, Command.Error> = .success("")
        if let location = workingDirectory {
          try! FileManager.default.do(in: location) {
            result = command.execute(with: modifiedArguments)
          }
        } else {
          result = command.execute(with: modifiedArguments)
        }
        var output: StrictString = ""
        var error: StrictString = ""
        var exitCode: Int = Command.Error.successCode
        switch result {
        case .success(let outputReceived):
          output = outputReceived
        case .failure(let thrown):
          if let captured = thrown.output {
            output = captured
          }
          error = thrown.presentableDescription()
          exitCode = thrown.exitCode
        }

        if ¬output.isEmpty {
          print(output, to: &report)
        }
        if ¬error.isEmpty {
          print(error, to: &report)
        }
        print(exitCode, to: &report)

        postprocess(&report)

        SDGPersistenceTestUtilities.compare(
          report,
          against: specification,
          overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing,
          file: file,
          line: line
        )
      }
    }
  }
}
