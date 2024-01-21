//
//  ContractMacro+ExtensionMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - ContractMacro + ExtensionMacro
extension ContractMacro: ExtensionMacro {
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol(Self.self) }
        
        let arguments = try Parser.arguments(from: node, decl: protocolDecl, context: context)
        
        return [try resolveExtension(protocolDecl, arguments)]
    }
}

// MARK: - Resolve Extension
private extension ContractMacro {
    
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
extension MemberBlockItemSyntax {
    
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
                            item: .expr("""
                                           \(raw: protocolDecl.name.text)Resolver(resolver).unravel(implementation: implementation)
                                       """)
                        )
                    )
                )
            )
        )
    }
}
