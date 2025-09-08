//
//  AssemblableMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// Макрос сборщика
public struct AssemblableMacro: PeerMacro, ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 providingPeersOf declaration: some DeclSyntaxProtocol,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let arguments = try Parser.arguments(from: node, declaration: declaration, context: context)
        guard arguments.options.contains(.freestanding) else { return [] }
        return [.init(try assembleClass(arguments)),
                .init(try resolverClass(arguments))]
    }
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        let arguments = try Parser.arguments(from: node, declaration: declaration, context: context)
        guard !arguments.options.contains(.freestanding) else { return [] }
        return [try assembleExtension(arguments)]
    }
}
