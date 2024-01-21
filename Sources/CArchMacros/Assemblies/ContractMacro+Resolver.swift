//
//  ContractMacro+Resolver.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - ResolverClass
extension ContractMacro {
    
    /// Возвращает декларацию класс X-Resolver
    /// - Parameters:
    ///   - protocolDecl: `ProtocolDeclSyntax`
    ///   - arguments: `Arguments`
    static func resolverClass(_ protocolDecl: ProtocolDeclSyntax, _ arguments: Arguments) throws -> ClassDeclSyntax {
        .init(
            modifiers: try .resolverClass(from: arguments),
            name: try .resolverClass(from: protocolDecl),
            memberBlock: .init(
                members: .init(
                    arrayLiteral:
                    try .resolverProperties(),
                    try .resolverClassInitializer(arguments),
                    try .resolverClassResolverFunction(protocolDecl, arguments)
                )
            )
        )
    }
}

// MARK: - Modifiers
private extension DeclModifierListSyntax {
    
    static func resolverClass(from arguments: ContractMacro.Arguments) throws -> DeclModifierListSyntax {
        .init {
            if let visibility = arguments.visibility {
                .init(name: visibility.syntax)
            }
            DeclModifierSyntax(name: .keyword(.final))
        }
    }
}

// MARK: - Name
private extension TokenSyntax {
    
    static func resolverClass(from protocolDecl: ProtocolDeclSyntax) throws -> TokenSyntax {
        .init(stringLiteral: "\(protocolDecl.name.text)Resolver")
    }
}

// MARK: - Properties
private extension MemberBlockItemSyntax {
    
    static func resolverProperties() throws -> MemberBlockItemSyntax {
        .init(
            decl: VariableDeclSyntax(
                modifiers: .init(
                    arrayLiteral: .init(
                        name: .keyword(.private)
                    )
                ),
                bindingSpecifier: .keyword(.let),
                bindings: .init(
                    arrayLiteral: .init(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("resolver")
                        ),
                        typeAnnotation: .init(
                            type: TypeSyntax(
                                stringLiteral: "DIResolver"
                            )
                        )
                    )
                )
            )
        )
    }
}

// MARK: - Initializer
private extension MemberBlockItemSyntax {
    
    static func resolverClassInitializer(_ arguments: ContractMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: InitializerDeclSyntax(
                modifiers: .init(
                    itemsBuilder: {
                        if let visibility = arguments.visibility {
                            .init(name: visibility.syntax)
                        }
                    }
                ),
                signature: .init(
                    parameterClause: .init(
                        parameters: .init(
                            arrayLiteral: .init(
                                firstName: TokenSyntax(
                                    stringLiteral: "_"
                                ),
                                secondName: TokenSyntax(
                                    stringLiteral: "resolver"
                                ),
                                type: TypeSyntax(
                                    stringLiteral: "DIResolver"
                                )
                            )
                        )
                    )
                ),
                body: .init(
                    statements: .init(
                        arrayLiteral: .init(
                            item: .expr("self.resolver = resolver")
                        )
                    )
                )
            )
        )
    }
}

// MARK: - Resolver Function
private extension MemberBlockItemSyntax {
    
    static func resolverClassResolverFunction(_ protocolDecl: ProtocolDeclSyntax,
                                              _ arguments: ContractMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: FunctionDeclSyntax(
                modifiers: .init {
                    if let visibility = arguments.visibility {
                        .init(name: visibility.syntax)
                    }
                },
                name: TokenSyntax(
                    stringLiteral: "unravel"
                ),
                signature: .init(
                    parameterClause: .init(
                        parameters: .init(
                            arrayLiteral: .init(
                                firstName: TokenSyntax(
                                    stringLiteral: "implementation"
                                ),
                                type: TypeSyntax(
                                    stringLiteral: "\(protocolDecl.name.text)Implementations"
                                ),
                                defaultValue: .init(
                                    value: MemberAccessExprSyntax(
                                        declName: DeclReferenceExprSyntax(
                                            baseName: .identifier(
                                                try arguments.defaultImplementation
                                            )
                                        )
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
                    statementsBuilder: {
                        SwitchExprSyntax(
                            subject: ExprSyntax(
                                stringLiteral: "implementation"
                            ),
                            casesBuilder: {
                                SwitchCaseListSyntax(
                                    itemsBuilder: {
                                        for (implementationCase, implementationType) in arguments.implementations.countSorted {
                                            .init(
                                                label: .implementationCase(from: implementationCase),
                                                statementsBuilder: {
                                                    .returnImplementation(for: arguments.component, with: implementationType)
                                                }
                                            )
                                        }
                                    }
                                )
                            }
                        )
                    }
                )
            )
        )
    }
}

// MARK: - Resolve Case
private extension SwitchCaseSyntax.Label {
    
    static func implementationCase(from `case`: String) -> SwitchCaseSyntax.Label {
        .case(
            .init(
                caseItems: .init(
                    itemsBuilder: {
                        .init(
                            pattern: PatternSyntax(
                                stringLiteral: ".\(`case`)"
                            )
                        )
                    }
                )
            )
        )
    }
}

// MARK: - Return
private extension CodeBlockItemListSyntax {
    
    static func returnImplementation(for component: ContractMacro.Arguments.Component, with type: String) -> CodeBlockItemListSyntax {
        .init {
            ReturnStmtSyntax(
                expression: ExprSyntax(
                    CodeBlockItemSyntax.Item.unravelExp(
                        from: component,
                        name: type.replacingOccurrences(of: ".self", with: "")
                    )
                )
            )
        }
    }
}
