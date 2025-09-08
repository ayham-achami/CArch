//
//  ContractMacro.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Макрос, который добавить код внедрение зависимости для протокол
public struct ContractMacro: PeerMacro, ExtensionMacro {
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notSupported(Self.self) }
        
        try checkInheritanceSpecifier(protocolDecl, from: "AutoResolve", in: context)
        let arguments = try Parser.arguments(from: node, decl: protocolDecl, context: context)
        
        return [.init(try implementationsEnum(protocolDecl, arguments)),
                .init(try assembleClass(protocolDecl, arguments)),
                .init(try resolverClass(protocolDecl, arguments))]
    }
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notSupported(Self.self) }
        
        let arguments = try Parser.arguments(from: node, decl: protocolDecl, context: context)
        return [try resolveExtension(protocolDecl, arguments)]
    }
}
