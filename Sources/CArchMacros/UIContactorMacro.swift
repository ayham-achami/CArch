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
        let functions = functions(from: protocolDecl)
        let extensionDecl = try ExtensionDeclSyntax("extension \(raw: protocolDecl.name.text)") {
            for function in functions {
                function
            }
        }
        return [extensionDecl]
    }
    
    /// Возвращает все не асинхронные функций в протоколе
    /// - Parameter protocolDecl: `ProtocolDeclSyntax`
    /// - Returns: `[FunctionDeclSyntax]`
    private static func functions(from protocolDecl: ProtocolDeclSyntax) -> [FunctionDeclSyntax] {
        protocolDecl
            .memberBlock
            .members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter {
                $0.signature.effectSpecifiers?.asyncSpecifier == nil &&
                $0.signature.effectSpecifiers?.throwsSpecifier == nil &&
                $0.signature.returnClause == nil
            }.compactMap {
                $0.with(\.modifiers, $0.modifiers.withNonisolated())
                    .with(\.leadingTrivia, .newline)
                    .with(\.signature, $0.signature
                        .with(\.effectSpecifiers, $0.signature.effectSpecifiers)
                        .with(\.parameterClause, $0.signature.parameterClause))
                    .with(\.name, .identifier("nonisolated\($0.name.text.capitalizedFunctionName)"))
                    .with(\.body, .awaitSyntax($0))
            }
    }
}

// MARK: - DeclModifierListSyntax + Nonisolated
private extension DeclModifierListSyntax {
    
    func withNonisolated() -> Self {
        DeclModifierListSyntax {
            DeclModifierSyntax(name: .keyword(.nonisolated))
            for modifier in self {
                modifier
            }
        }.with(\.leadingTrivia, .newline)
    }
}

// MARK: - String + capitalizedFunctionName
private extension String {
    
    var capitalizedFunctionName: Self {
        prefix(1).uppercased() + dropFirst()
    }
}
