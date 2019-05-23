/*
 OptionInterface.swift

 This source file is part of the SDGCommandLine open source project.
 https://sdggiesbrecht.github.io/SDGCommandLine

 Copyright ©2019 Jeremy David Giesbrecht and the SDGCommandLine project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

/// An option.
public struct OptionInterface : Decodable {

    /// A unique identifier that can be compared across localizations to find corresponding options.
    internal var identifier: StrictString

    /// The name.
    internal var name: StrictString

    /// The description.
    internal var description: StrictString

    /// The type.
    internal var type: ArgumentInterface
}
