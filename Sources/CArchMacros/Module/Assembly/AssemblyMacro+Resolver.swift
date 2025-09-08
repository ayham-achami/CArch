//
//  AssemblyMacro+Resolver.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AssemblableMacro + Resolver
extension AssemblableMacro {
 
    static func resolverClass(_ arguments: Arguments) throws -> ClassDeclSyntax {
        .init(
            modifiers: try .resolverClass(arguments),
            name: try .resolverClass(arguments),
            memberBlock: .init(
                members: .init(
                    arrayLiteral:
                    try .resolverProperties(),
                    try .resolverClassInitializer(arguments),
                    try .resolverClassResolverFunction(arguments)
                )
            )
        )
    }
}

// MARK: - Modifiers
private extension DeclModifierListSyntax {
    
    static func resolverClass(_ arguments: AssemblableMacro.Arguments) throws -> DeclModifierListSyntax {
        .init {
            if arguments.options.contains(.public) {
                DeclModifierSyntax(name: .keyword(.public))
            }
            DeclModifierSyntax(name: .keyword(.final))
        }
    }
}

// MARK: - Name
private extension TokenSyntax {
    
    static func resolverClass(_ arguments: AssemblableMacro.Arguments) throws -> TokenSyntax {
        arguments.options.contains(.freestanding) ? "\(raw: arguments.type)Resolver" : "Resolver"
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
    
    static func resolverClassInitializer(_ arguments: AssemblableMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: InitializerDeclSyntax(
                modifiers: .init(
                    itemsBuilder: {
                        if arguments.options.contains(.public) {
                            .init(name: .keyword(.public))
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
    
    static func resolverClassResolverFunction(_ arguments: AssemblableMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: FunctionDeclSyntax(
                modifiers: .init {
                    if arguments.options.contains(.public) {
                        .init(name: .keyword(.public))
                    }
                },
                name: TokenSyntax(
                    stringLiteral: "unravel"
                ),
                signature: .init(
                    parameterClause: .init(
                        parameters: .init(
                            itemsBuilder: {}
                        )
                    ),
                    returnClause: .init(
                        type: TypeSyntax(
                            stringLiteral: arguments.type
                        )
                    )
                ),
                body: .init(
                    statements: .init(
                        itemsBuilder: {
                            .unravelExp(for: arguments)
                        }
                    )
                )
            )
        )
    }
}

// MARK: - CodeBlockItemSyntax + AssemblyMacro.Arguments
private extension CodeBlockItemSyntax {
    
    static func unravelExp(for arguments: AssemblableMacro.Arguments) -> CodeBlockItemSyntax {
        switch arguments.behavior {
        case .auto:
            .init(item: .unravelExp(from: .from(arguments.type) ?? .some, name: arguments.type))
        case .some:
            .init(item: .unravelExp(from: .some, name: arguments.type))
        }
    }
}
