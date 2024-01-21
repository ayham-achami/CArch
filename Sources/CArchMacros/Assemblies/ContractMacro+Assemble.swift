//
//  ContractMacro+Assemble.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - ContractMacro + AssembleClass
extension ContractMacro {
    
    /// Возвращает декларацию класс X-Assemble
    /// - Parameters:
    ///   - protocolDecl: `ProtocolDeclSyntax`
    ///   - arguments: `Arguments`
    static func assembleClass(_ protocolDecl: ProtocolDeclSyntax, _ arguments: Arguments) throws -> ClassDeclSyntax {
        .init(
            modifiers: try .assembleClass(arguments),
            name: try .assembleClass(from: protocolDecl),
            inheritanceClause: try .assembleClass(),
            memberBlock: .init(
                members: .init(
                    arrayLiteral: try .assembleClassAssembleFunction(arguments)
                )
            )
        )
    }
}

// MARK: - Modifier
private extension DeclModifierListSyntax {
    
    static func assembleClass(_ arguments: ContractMacro.Arguments) throws -> DeclModifierListSyntax {
        .init {
            if arguments.isPublicAssembly {
                DeclModifierSyntax(name: .keyword(.public))
            }
            DeclModifierSyntax(name: .keyword(.final))
        }
    }
}

// MARK: - Name
private extension TokenSyntax {
    
    static func assembleClass(from protocolDecl: ProtocolDeclSyntax) throws -> TokenSyntax {
        .init(stringLiteral: "\(protocolDecl.name.text)Assembly")
    }
}

// MARK: - Inheritance
private extension InheritanceClauseSyntax {
    
    static func assembleClass() throws -> InheritanceClauseSyntax {
        .init(
            inheritedTypes: .init(
                arrayLiteral: .init(
                    type: TypeSyntax(
                        stringLiteral: "DIAssembly"
                    )
                )
            )
        )
    }
}

// MARK: - Assemble Function
private extension MemberBlockItemSyntax {
    
    static func assembleClassAssembleFunction(_ arguments: ContractMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: FunctionDeclSyntax(
                modifiers: .init {
                    if arguments.isPublicAssembly {
                        .init(name: .keyword(.public))
                    }
                },
                name: TokenSyntax(
                    stringLiteral: "assemble"
                ),
                signature: .init(
                    parameterClause: .init(
                        parameters: .init(
                            arrayLiteral: .init(
                                firstName: TokenSyntax(
                                    stringLiteral: "container"
                                ),
                                type: TypeSyntax(
                                    stringLiteral: "DIContainer"
                                )
                            )
                        )
                    )
                ),
                body: .init(
                    statements: .init(
                        itemsBuilder: {
                            for implementation in arguments.implementations.values.countSorted {
                                .init(item: .recordExp(from: arguments.component, name: implementation))
                            }
                        }
                    )
                )
            )
        )
    }
}
