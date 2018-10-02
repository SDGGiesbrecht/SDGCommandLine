/*
 OptionInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine/SDGCommandLine

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct _OptionInterface : Encodable {
    internal var identifier: StrictString
    internal var name: StrictString
    internal var description: StrictString
    internal var type: _ArgumentInterface
}
