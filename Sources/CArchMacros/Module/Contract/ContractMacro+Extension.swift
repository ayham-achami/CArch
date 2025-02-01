//
//  ContractMacro+Extension.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Resolve Extension
extension ContractMacro {
    
    /// Возвращает декларацию Extension типа `protocolDecl.name.text`
    /// - Parameter protocolDecl: `ProtocolDeclSyntax`
    static func resolveExtension(_ protocolDecl: ProtocolDeclSyntax, _ arguments: Arguments) throws -> ExtensionDeclSyntax {
        .init(
            modifiers: .init(
                itemsBuilder: {
                    if let visibility = arguments.visibility {
                        .init(name: visibility.syntax)
                    }
                }
            ),
            extendedType: TypeSyntax(
                stringLiteral: protocolDecl.name.text
            ),
            memberBlock: .init(
                members: .init(
                    arrayLiteral: try .resolveFunction(protocolDecl, arguments)
                )
            )
        )
    }
}

// MARK: - Resolve Function
private extension MemberBlockItemSyntax {
    
    static func resolveFunction(_ protocolDecl: ProtocolDeclSyntax, _ arguments: ContractMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: FunctionDeclSyntax(
                modifiers: .init(
                    itemsBuilder: {
                        .init(name: .keyword(.static))
                    }
                ),
                name: TokenSyntax(
                    stringLiteral: "resolve"
                ),
                signature: .init(
                    parameterClause: .init(
                        parameters: .init(
                            arrayLiteral: .init(
                                firstName: TokenSyntax(
                                    stringLiteral: "from"
                                ),
                                secondName: TokenSyntax(
                                    stringLiteral: "resolver"
                                ),
                                type: TypeSyntax(
                                    stringLiteral: "DIResolver"
                                ),
                                trailingComma: .commaToken()
                            ),
                            .init(
                                firstName: TokenSyntax(
                                    stringLiteral: "implementation"
                                ),
                                type: TypeSyntax(
                                    stringLiteral: "\(protocolDecl.name.text)Implementations"
                                ),
                                defaultValue: .init(
                                    value: ExprSyntax(
                                        stringLiteral: ".\(try arguments.defaultImplementation)"
                                    )
                                )
                            )
                        )
                    ),
                    returnClause: .init(
                        type: TypeSyntax(
                            stringLiteral: protocolDecl.name.text
                        )
                    )
                ),
                body: .init(
                    statements: .init(
                        arrayLiteral: .init(
                            item: .expr("\(raw: protocolDecl.name.text)Resolver(resolver).unravel(implementation: implementation)")
                        )
                    )
                )
            )
        )
    }
}
