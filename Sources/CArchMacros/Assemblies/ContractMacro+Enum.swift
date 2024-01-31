//
//  ContractMacro+Enum.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - ContractMacro + ImplementationsEnum
extension ContractMacro {
    
    /// Возвращает декларацию Enum типов имплементации
    /// - Parameters:
    ///   - protocolDecl: `ProtocolDeclSyntax`
    ///   - arguments: `Arguments`
    static func implementationsEnum(_ protocolDecl: ProtocolDeclSyntax, _ arguments: Arguments) throws -> EnumDeclSyntax {
        .init(
            modifiers: .init(
                itemsBuilder: {
                    if let visibility = arguments.visibility {
                        .init(name: visibility.syntax)
                    }
                }
            ),
            name: TokenSyntax(
                stringLiteral: "\(protocolDecl.name.text)Implementations"
            ),
            inheritanceClause: .init(
                inheritedTypes: .init(
                    arrayLiteral: .init(
                        type: TypeSyntax(
                            stringLiteral: "Equatable"
                        )
                    )
                )
            ),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        for implementation in arguments.implementations.keys.countSorted {
                            EnumCaseDeclSyntax(
                                elements: .init {
                                    if implementation.isDefault {
                                        .init(
                                            name: .init(stringLiteral: "`\(implementation)`")
                                        )
                                    } else {
                                        .init(
                                            name: .init(
                                                stringLiteral: implementation
                                            )
                                        )
                                    }
                                }
                            )
                        }
                    }
                )
            )
        )
    }
}
