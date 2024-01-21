//
//  SyncAliasMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Макрос, который добавить alias не асинхронной функции всех асинхронных функций
public struct SyncAliasMacro: ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol(Self.self) }
        
        try protocolDecl.checkInheritanceSpecifier(from: "ErrorAsyncHandler", in: context)
        
        return [try syncExtension(from: protocolDecl, with: context)]
    }
}

// MARK: - SyncAliasMacro + Sync Functions
private extension SyncAliasMacro {
    
    /// <#Description#>
    /// - Parameters:
    ///   - protocolDecl: <#protocolDecl description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func syncExtension(from protocolDecl: ProtocolDeclSyntax,
                              with context: some MacroExpansionContext) throws -> ExtensionDeclSyntax {
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
                members: try .init(
                    itemsBuilder: {
                        let functions = try syncFunctions(from: protocolDecl, with: context)
                        for function in functions {
                            function
                        }
                    }
                )
            )
        )
    }
}

// MARK: - SyncAliasMacro + Sync Functions
private extension SyncAliasMacro {
    
    /// <#Description#>
    /// - Parameters:
    ///   - protocolDecl: <#protocolDecl description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func syncFunctions(from protocolDecl: ProtocolDeclSyntax, with context: some MacroExpansionContext) throws -> [MemberBlockItemSyntax] {
        let syncFunctions = protocolDecl.asyncFunctions.map { function in
            MemberBlockItemSyntax(
                decl: FunctionDeclSyntax(
                    name: TokenSyntax(
                        stringLiteral: function.name.text
                    ),
                    signature: function.signature,
                    body: .init(
                        statementsBuilder: {
                            .init(
                                item: .taskExpr(function)
                            )
                        }
                    )
                )
            )
        }
        let syncThrowsFunction = protocolDecl.asyncThrowsFunctions.map { function in
            MemberBlockItemSyntax(
                decl: FunctionDeclSyntax(
                    name: TokenSyntax(
                        stringLiteral: function.name.text
                    ),
                    signature: function.signature,
                    body: .init(
                        statementsBuilder: {
                            .init(
                                item: .taskDoCatchExpr(function)
                            )
                        }
                    )
                )
            )
        }
        return syncFunctions + syncThrowsFunction
    }
}

// MARK: - ProtocolDeclSyntax + Functions
private extension ProtocolDeclSyntax {
    
    var asyncFunctions: [FunctionDeclSyntax] {
        memberBlock
            .members
            .compactMap {
                $0.decl.as(FunctionDeclSyntax.self)
            }.filter {
                $0.signature.returnClause == nil &&
                $0.signature.effectSpecifiers?.throwsSpecifier == nil &&
                $0.signature.effectSpecifiers?.asyncSpecifier != nil
            }.map {
                $0.withoutAsyncSpecifier()
            }
    }
    
    var asyncThrowsFunctions: [FunctionDeclSyntax] {
        memberBlock
            .members
            .compactMap {
                $0.decl.as(FunctionDeclSyntax.self)
            }.filter {
                $0.signature.returnClause == nil &&
                $0.signature.effectSpecifiers?.asyncSpecifier != nil &&
                $0.signature.effectSpecifiers?.throwsSpecifier != nil
            }.map {
                $0.withoutAsyncThrowsSpecifier()
            }
    }
}

// MARK: - FunctionDeclSyntax + Functions
private extension FunctionDeclSyntax {
    
    func withoutAsyncSpecifier() -> Self {
        guard
            let effectSpecifiers = signature.effectSpecifiers
        else { return self }
        return with(\.signature, signature.with(\.effectSpecifiers, effectSpecifiers.with(\.asyncSpecifier, nil)))
    }
    
    func withoutAsyncThrowsSpecifier() -> Self {
        guard
            let effectSpecifiers = signature.effectSpecifiers
        else { return self }
        return with(\.signature, signature.with(\.effectSpecifiers, effectSpecifiers.with(\.asyncSpecifier, nil).with(\.throwsSpecifier, nil)))
    }
}
