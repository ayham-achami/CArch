//
//  AssemblyMacro+Extension.swift
//

import SwiftSyntax

// MARK: - AssemblableMacro + Extension
extension AssemblableMacro {
    
    static func assembleExtension(_ arguments: Arguments) throws -> ExtensionDeclSyntax {
        .init(
            extendedType: TypeSyntax(
                stringLiteral: arguments.type
            ),
            memberBlock: .init(
                members: try .init(
                    itemsBuilder: {
                        try assembleClass(arguments)
                        try resolverClass(arguments)
                    }
                )
            )
        )
    }
}
