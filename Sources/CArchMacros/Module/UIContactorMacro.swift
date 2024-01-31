//
//  UIContactorMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Макрос, который добавить nonisolated alias всех не асинхронных функций
public struct UIContactorMacro: ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol(Self.self) }
        return [
            .init(
                modifiers: .init(
                    itemsBuilder: {
                        for modifier in protocolDecl.modifiers {
                            modifier
                        }
                    }
                ),
                extendedType: TypeSyntax(
                    stringLiteral: protocolDecl.name.text
                ),
                memberBlock: .init(
                    members: .init {
                        let functions = functions(from: protocolDecl)
                        for function in functions {
                            function
                        }
                    }
                )
            )
        ]
    }
    
    /// Возвращает все не асинхронные функций в протоколе
    /// - Parameter protocolDecl: `ProtocolDeclSyntax`
    /// - Returns: `[FunctionDeclSyntax]`
    private static func functions(from protocolDecl: ProtocolDeclSyntax) -> [FunctionDeclSyntax] {
        protocolDecl
            .memberBlock
            .members
            .compactMap {
                $0.decl.as(FunctionDeclSyntax.self)
            }.filter {
                $0.signature.effectSpecifiers?.asyncSpecifier == nil &&
                $0.signature.effectSpecifiers?.throwsSpecifier == nil &&
                $0.signature.returnClause == nil
            }.map { function in
                .init(
                    modifiers: .init(
                        arrayLiteral: .init(
                            name: .keyword(.nonisolated)
                        )
                    ),
                    name: TokenSyntax(
                        stringLiteral: "nonisolated\(function.name.text.capitalizedFunctionName)"
                    ),
                    signature: function.signature,
                    body: .init(
                        statementsBuilder: {
                            .init(item: .taskExpr(function))
                        }
                    )
                )
            }
    }
}
