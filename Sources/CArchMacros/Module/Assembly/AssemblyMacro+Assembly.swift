//
//  AssemblyMacro+Assembly.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - AssemblableMacro + AssembleClass
extension AssemblableMacro {
    
    /// Возвращает декларацию класс X-Assemble
    /// - Parameters:
    ///   - protocolDecl: `ProtocolDeclSyntax`
    ///   - arguments: `Arguments`
    static func assembleClass(_ arguments: Arguments) throws -> ClassDeclSyntax {
        .init(
            modifiers: try .assembleClass(arguments),
            name: try .assembleClass(for: arguments),
            inheritanceClause: try .assembleClass(),
            memberBlock: .init(
                members: .init(
                    arrayLiteral: try .assembleClassAssembleFunction(arguments)
                )
            )
        )
    }
}

// MARK: - Name
private extension TokenSyntax {
    
    static func assembleClass(for arguments: AssemblableMacro.Arguments) throws -> TokenSyntax {
        arguments.options.contains(.freestanding) ? "\(raw: arguments.type)Assembly" : "Assembly"
    }
}

// MARK: - Modifier
private extension DeclModifierListSyntax {
    
    static func assembleClass(_ arguments: AssemblableMacro.Arguments) throws -> DeclModifierListSyntax {
        .init {
            if arguments.options.contains(.public) {
                DeclModifierSyntax(name: .keyword(.public))
            }
            DeclModifierSyntax(name: .keyword(.final))
        }
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
    
    static func assembleClassAssembleFunction(_ arguments: AssemblableMacro.Arguments) throws -> MemberBlockItemSyntax {
        .init(
            decl: FunctionDeclSyntax(
                modifiers: .init {
                    if arguments.options.contains(.public) {
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
                            .recordExp(for: arguments)
                        }
                    )
                )
            )
        )
    }
}

// MARK: - CodeBlockItemSyntax + AssemblyMacro.Arguments
private extension CodeBlockItemSyntax {
    
    static func recordExp(for arguments: AssemblableMacro.Arguments) -> CodeBlockItemSyntax {
        switch arguments.behavior {
        case .auto:
            .init(item: .recordExp(from: .from(arguments.type) ?? .some, name: arguments.type))
        case .some:
            .init(item: .recordExp(from: .some, name: arguments.type))
        }
    }
}
